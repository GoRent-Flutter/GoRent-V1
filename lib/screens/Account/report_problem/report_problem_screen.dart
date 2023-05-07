import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/owner_view/owner_view_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../user_account_screen.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({Key? key}) : super(key: key);

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
      final imageId =
          FirebaseDatabase.instance.reference().child(id!).push().key;

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
        builder: (context) => const OwnerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? selectedOption;
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
            icon:
                Image.asset('assets/icons/Red_back.png', width: 24, height: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserAccountScreen()),
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
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(children: <Widget>[
            Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: Container(
                alignment: AlignmentDirectional.centerEnd,
                child: const Text(
                  "إذا كنت تواجه مشكلة في GoRent، فقد وصلت إلى المكان الصحيح. يرجى استخدام هذا النموذج لإخبارنا عن المشكلة التي تواجهها.",
                  style: TextStyle(
                    fontFamily: 'Scheherazade_New',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryHint,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            Positioned(
              child: Padding(
                padding: EdgeInsets.only(
                    top: size.width / 2 - 60,
                    left: size.width / 2 - 20,
                    right: 16),
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
                  hint: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اختر مشكلة',
                      style: TextStyle(
                          fontFamily: 'Scheherazade_New', fontSize: 16),
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: primaryRed),
                ),
              ),
            ),
            Positioned(
              top: size.width / 2 + 15,
              left: size.width /2 + 82,
              right: 16,
              child: Text(
                'وصف المشكلة',
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  fontSize: 16
                ),
              ),
            ),
            Positioned(
              top: size.width / 2 + 50,
              left: 16,
              right: 16,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'أدخل وصفًا للمشكلة',
                            hintStyle: const TextStyle(
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
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('إضافة صورة'),
                    
                      onPressed: getImage,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: primaryRed,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submitForm();
                          }
                        },
                        child: const Text(
                          'إرسال',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _images.isNotEmpty
                ? Positioned(
                    top: size.width / 2 + 110,
                    right: 16,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          final file = _images[index];
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(file),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -5,
                                right: -5,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _images.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : Container(),
          ]),
        ));
  }
}
