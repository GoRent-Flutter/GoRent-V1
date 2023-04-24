import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:image_picker/image_picker.dart';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({Key? key}) : super(key: key);

  @override
  _AddApartmentScreenState createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _type = 'استئجار';
  late String _city = '';
  late String _address1 = '';
  late String _address2 = '';
  late int _numRooms = 0;
  late int _numBathrooms = 0;
  late int _numVerandas = 0;
  late int _numSalons = 0;
  late int _numKitchens = 0;
  late int _OwnerID = 0;
  late double _size = 0.0;
  late double _price = 0.0;
  late double _latitude = 0.0;
  late double _longitude = 0.0;
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Generate a unique ID for the new apartment
      final id = FirebaseDatabase.instance.reference().push().key;

      // Create a new instance of the apartment with the given data
      final apartment = {
        'type': _type,
        'city': _city,
        'address1': _address1,
        'address2': _address2,
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
      };

      // Upload the apartment data to the appropriate Firebase Realtime Database location
      if (_type == 'استئجار') {
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
        if (_type =='بيع') {
          FirebaseDatabase.instance
              .reference()
              .child('sale')
              .child(id)
              .child('images')
              .push()
              .set(downloadUrl);
        }
        else{
           FirebaseDatabase.instance
              .reference()
              .child('rent')
              .child(id)
              .child('images')
              .push()
              .set(downloadUrl);
        }
      }

      // Display a success message and pop the screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Apartment added successfully'),
        ),
      );
      Navigator.pop(context);
    }
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
                  decoration: InputDecoration(labelText: 'Type'),
                  items: ['بيع', 'استئجار']
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
                  validator: (value) {
                    if (value == null) {
                      return 'Please choose the type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'City'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the city';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _city = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address 1'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _address1 = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address 2'),
                  onSaved: (value) {
                    _address2 = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number of rooms'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of rooms';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _numRooms = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number of bathrooms'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of bathrooms';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _numBathrooms = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number of verandas'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of verandas';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _numVerandas = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number of salons'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of salons';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _numSalons = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number of kitchens'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the number of kitchens';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _numKitchens = int.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Size'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the size';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _size = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the latitude';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _latitude = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the longitude';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _longitude = double.parse(value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Owner ID'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the Owner ID';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _OwnerID = int.parse(value!.toString());
                  },
                ),
                SizedBox(height: 16),
                Text('Images'),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: getImage,
                        style: TextButton.styleFrom(
                          side: const BorderSide(width: 1, color: primaryWhite),
                          backgroundColor: primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(37.0),
                          ),
                        ),
                        child: Text('Add Image'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(_images[index]),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: TextButton.styleFrom(
                          side: const BorderSide(width: 1, color: primaryWhite),
                          backgroundColor: primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(37.0),
                          ),
                        ),
                        child: Text('Submit'),
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
