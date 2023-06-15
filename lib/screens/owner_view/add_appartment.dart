// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/owner_view/succes_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


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
  late String _OwnerID = 'mahmoad@gmail.com-GROW';
  late double _size = 0.0;
  late double _price = 0.0;
  late double _latitude = 0.0;
  late double _longitude = 0.0;
  late String _description = '';
  List<File> _images = [];
  bool isApproved = false;
  bool _isLoading = false;

  final picker = ImagePicker();

  List<String> _selectedNeighborhoods = [];
  List<String> _availableNeighborhoods = [
    'مدرسة',
    'روضة',
    'جامع',
    'سوبر ماركت',
    'مطعم',
  ];

  GoogleMapController? mapController;
  LatLng _selectedLatLng = LatLng(0, 0); // Initialize with default coordinates

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

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

  void _openMapPopup() async {
    LatLng? selectedLocation = LatLng(0.0, 0.0);

    // Get current location
    LocationData? currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print('Error getting current location: $e');
    }

    final result = await showDialog<LatLng>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اختار الموقع'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {},
              onTap: (LatLng location) {
                selectedLocation = location;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLocation?.latitude ?? 0.0,
                  currentLocation?.longitude ?? 0.0,
                ),
                zoom: 15,
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(selectedLocation);
              },
              child: Text('اختار'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
      });
    }
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
      'neighborhoods': _selectedNeighborhoods, // Add the selected neighborhoods
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
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField<String>(
                    value: _type,
                    decoration: InputDecoration(
                      labelText: 'النوع',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                      alignLabelWithHint: true,
                      hintTextDirection: TextDirection.rtl,
                    ),
                    items: ['بيع', 'اجار']
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(
                                type,
                                textDirection: TextDirection.rtl,
                              ),
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
                        return 'الرجاء اختيار النوع';
                      }
                      return null;
                    },
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DropdownButtonFormField<String>(
                    value: _city,
                    decoration: InputDecoration(
                      labelText: 'المدينة',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                      alignLabelWithHint: true,
                    ),
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
                        return 'الرجاء اختيار المدينة'; // Update the error message to Arabic
                      }
                      return null;
                    },
                    dropdownColor: Colors
                        .white, // Add this line to set the dropdown menu color
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'العنوان 1',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'يرجى إدخال العنوان';
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
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'عدد الغرف',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'يرجى إدخال عدد الغرف';
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
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'عدد الحمامات',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'يرجى إدخال عدد الحمامات';
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
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'عدد الشرفات',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'الرجاء إدخال عدد الشرفات';
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
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'عدد الصالونات',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'الرجاء إدخال عدد الصالونات';
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
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'عدد المطابخ',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'الرجاء إدخال عدد المطابخ';
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
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'المساحة',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'الرجاء إدخال المساحة';
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
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'السعر',
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Scheherazade_New',
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'الرجاء إدخال السعر';
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
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'الوصف',
                        alignLabelWithHint: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null, // Allow unlimited number of lines
                      onChanged: (value) {
                        setState(() {
                          _description = value;
                        });
                      },
                      onSubmitted: (value) {
                        // Perform validation here if needed
                      },
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
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
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'قريب من : ',
                    style: TextStyle(
                      fontFamily: 'Scheherazade_New',
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _availableNeighborhoods.map((neighborhood) {
                    final isSelected =
                        _selectedNeighborhoods.contains(neighborhood);
                    return FilterChip(
                      label: Text(neighborhood),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedNeighborhoods.add(neighborhood);
                          } else {
                            _selectedNeighborhoods.remove(neighborhood);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _openMapPopup,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          primary: primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          ' اختار الموقع',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
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
