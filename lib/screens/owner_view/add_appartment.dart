// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/owner_view/succes_screen.dart';
import 'package:image_picker/image_picker.dart';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({Key? key}) : super(key: key);

  @override
  _AddApartmentScreenState createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _type = 'بيع';
  late String _city = 'رام الله';
  late String _address1 = '';
  late int _numRooms = 0;
  late int _numBathrooms = 0;
  late int _numVerandas = 0;
  late int _numSalons = 0;
  late int _numKitchens = 0;
  late String _OwnerID = '';
  late double _size = 0.0;
  late double _price = 0.0;
  late double _latitude = 0.0;
  late double _longitude = 0.0;
  late String _description = '';
  List<File> _images = [];
  bool isApproved = false;
  bool _isLoading = false;

  final picker = ImagePicker();
  

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('قم بآدخال الصور المطلوبة'),
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
      }
    });
  }

  Future<void> _submitForm() async {

 setState(() {
      _isLoading = true;
    });


      // Generate a unique ID for the new apartment
      final id = FirebaseDatabase.instance.reference().push().key;

      // Create a new instance of the apartment with the given data
      final apartment = {
        'type': _type,
        'city': _city,
        'address1': _address1,
        'numRooms': _numRooms,
        'numBathrooms': _numBathrooms,
        'numVerandas': _numVerandas,
        'numSalons': _numSalons,
        'numKitchens': _numKitchens,
        'size': _size,
        'price': _price,
        'latitude': _latitude,
        'longitude': _longitude,
        'description': _description,
        'images': [],
        'isApproves': isApproved,
        'OwnerID': _OwnerID,
      };

      // Upload the apartment data to the appropriate Firebase Realtime Database location
      if (_type == 'اجار') {
        FirebaseDatabase.instance
            .reference()
            .child('rent')
            .child(id!)
            .set(apartment);
      } else if (_type == 'بيع') {
        FirebaseDatabase.instance
            .reference()
            .child('sale')
            .child(id!)
            .set(apartment);
      }

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
        final snapshot = await uploadTask.whenComplete(() => null);

        // Get the download URL of the uploaded image
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Add the download URL of the uploaded image to the apartment data
        // Add the download URL of the uploaded image to the apartment data

        if (_type == 'اجار') {
          FirebaseDatabase.instance
              .reference()
              .child('rent')
              .child(id)
              .child('images')
              .push()
              .set(downloadUrl);
        } else if (_type == 'بيع') {
          FirebaseDatabase.instance
              .reference()
              .child('sale')
              .child(id)
              .child('images')
              .push()
              .set(downloadUrl);
        }
      }
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(),
        ),
      );

    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryWhite,
        title: const Text(
          'اضافة عقار',
          style: TextStyle(
            color: primaryRed,
            fontSize: 21.0,
          ),
        ),
      ),
      backgroundColor: primaryWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration:const InputDecoration(labelText: 'Type'),
                  items: ['بيع', 'اجار']
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _type = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please choose the type';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _city,
                  decoration: const InputDecoration(labelText: 'City'),
                  items: ['رام الله', 'نابلس', 'بيت لحم', 'طولكرم']
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _city = value!;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _city = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please choose the city';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<bool>(
                  value: isApproved,
                  decoration: const InputDecoration(labelText: 'isApproved'),
                  items: const [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('True'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('False'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      isApproved = value!;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      isApproved = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please choose a value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration:const InputDecoration(labelText: 'Address 1'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _address1 = value;
                  },
                  onSaved: (value) {
                    _address1 = value!;
                  },
                ),
                TextFormField(
                  decoration:const  InputDecoration(labelText: 'Number of rooms'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of rooms';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _numRooms = int.parse(value);
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      _numRooms = int.parse(value!);
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Number of bathrooms'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of bathrooms';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _numBathrooms = int.parse(value);
                    });
                  },
                  onSaved: (value) {
                    _numBathrooms = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration:const  InputDecoration(labelText: 'Number of verandas'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of verandas';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _numVerandas = int.parse(value);
                    });
                  },
                  onSaved: (value) {
                    _numVerandas = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Number of salons'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of salons';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _numSalons = int.parse(value);
                    });
                  },
                  onSaved: (value) {
                    _numSalons = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Number of kitchens'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of kitchens';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _numKitchens = int.parse(value);
                    });
                  },
                  onSaved: (value) {
                    _numKitchens = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration:const InputDecoration(labelText: 'Size'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the size';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _size = double.parse(value);
                    });
                  },
                  onSaved: (value) {
                    _size = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _price = double.parse(value);
                    });
                  },
                  onSaved: (value) {
                    _price = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the latitude';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _latitude = double.parse(value);
                    });
                  },
                  onSaved: (value) {
                    _latitude = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the longitude';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _longitude = double.parse(value);
                    });
                  },
                  onSaved: (value) {
                    _longitude = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Owner_id'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _OwnerID = value;
                  },
                  onSaved: (value) {
                    _OwnerID = value!;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Images'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child:               ElevatedButton(
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
                    ),
                  ],
                ),
               const SizedBox(height: 8),
               const Text(
                'الصور المرفقة:',
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  fontSize: 16,
                ),
              ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Remove Image'),
                                content: const Text(
                                    'Are you sure you want to remove this image?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _images.removeAt(index);
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Remove'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Image.file(
                                _images[index],
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _images.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                            Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () {
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
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : const Text(
                                'ارسال',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}