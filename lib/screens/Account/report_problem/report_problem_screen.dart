import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:image_picker/image_picker.dart';
import '../user_account_screen.dart';
import 'success_screen.dart';

class ReportProblemScreen extends StatefulWidget {
  final int currentIndex;
  const ReportProblemScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  ReportProblemState createState() => ReportProblemState();
}

class ReportProblemState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _type = '';
  late String _description = '';
  List<File> _images = [];

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  void _submitForm() {
    // Check if any of the fields are empty
    if (_type.isEmpty || _description.isEmpty || _images.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('يرجى ملء جميع الحقول المطلوبة.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    // Generate a unique ID for the new apartment
    final id = FirebaseDatabase.instance.reference().push().key;

    // Create a new instance of the apartment with the given data
    final issue = {
      'type': _type,
      'description': _description,
      'images': [],
    };

    FirebaseDatabase.instance
        .reference()
        .child('problems')
        .child(id!)
        .set(issue);

    // Upload the apartment images to Firebase Storage
    for (final imageFile in _images) {
      // Generate a unique ID for the new image
      final imageId = FirebaseDatabase.instance.reference().push().key;

      // Upload the image file to Firebase Storage
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('$id/$imageId.jpg');
      final uploadTask = storageReference.putFile(imageFile);
      uploadTask.whenComplete(() => null).then((snapshot) async {
        // Get the download URL of the uploaded image
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Add the download URL of the uploaded image to the apartment data
        FirebaseDatabase.instance
            .reference()
            .child('problems')
            .child(id)
            .child('images')
            .push()
            .set(downloadUrl);
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SuccessScreen(),
      ),
    );
  }

  String? selectedOption = 'مشكلة في معلومات الحساب'; // Default selected option

  @override
  Widget build(BuildContext context) {
    final List<String> options = [
      'مشكلة في معلومات الحساب',
      'مشكلة في الرسائل',
      'مشكلة في العقارات المعروضة',
      'أخرى',
    ];

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 1,
        leading: IconButton(
          icon: Image.asset('assets/icons/Red_back.png', width: 24, height: 24),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserAccountScreen(currentIndex: widget.currentIndex ,)),
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16, top: 16),
            child: Text(
              'الإبلاغ عن مشكلة',
              style: TextStyle(
                color: primaryRed,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 20),
              const Text(
                "إذا كنت تواجه مشكلة في GoRent، فقد وصلت إلى المكان الصحيح. يرجى استخدام هذا النموذج لإخبارنا عن المشكلة التي تواجهها.",
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: primaryHint,
                ),
                textDirection: TextDirection.rtl,
              ),
              SizedBox(height: 20),
Container(
                color: Colors.white,
                child: DropdownButton<String>(
                  value: selectedOption,
                  items: options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: primaryHint,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                      _type = value ?? '';
                    });
                  },
                  hint: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اختر مشكلة',
                      style: TextStyle(fontFamily: 'Scheherazade_New', fontSize: 16),
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: primaryRed),
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'وصف المشكلة',
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,

                child: TextFormField(
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'أدخل وصفًا للمشكلة',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يجب إدخال وصف المشكلة';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: getImage,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  primary: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'إرفاق صور',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              const Text(
                'الصور المرفقة:',
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(_images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  primary: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'ارسال',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
