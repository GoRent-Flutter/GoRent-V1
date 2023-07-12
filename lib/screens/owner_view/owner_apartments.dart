import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../constraints.dart';
import 'edit_apartment_screen.dart';

class Apartment {
  final String city;
  final String type;
  final int price;
  final String address1;

  Apartment({
    required this.city,
    required this.type,
    required this.price,
    required this.address1,
  });
}

class OwnerApartmentsScreen extends StatefulWidget {
  final String ownerId;

  OwnerApartmentsScreen({required this.ownerId});

  @override
  _OwnerApartmentsScreenState createState() => _OwnerApartmentsScreenState();
}

class _OwnerApartmentsScreenState extends State<OwnerApartmentsScreen> {
  late DatabaseReference _databaseRef;
  late DatabaseReference _databaseRef2;
  List<Apartment> _apartments = [];

  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.reference().child('rent');
    _databaseRef2 = FirebaseDatabase.instance.reference().child('sale');

    _fetchApartments();
  }

  void _fetchApartments() {
    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final rentApartments = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          _apartments = rentApartments.entries
              .where((entry) => entry.value['OwnerID'] == widget.ownerId)
              .map((entry) {
            final rentedApartment = Map<String, dynamic>.from(entry.value);
            return Apartment(
              city: rentedApartment['city'] as String,
              type: rentedApartment['type'] as String,
              price: rentedApartment['price'] as int,
              address1: rentedApartment['address1'] as String,
            );
          }).toList();
        });
      }
    });

    _databaseRef2.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final saleApartments = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          _apartments.addAll(saleApartments.entries
              .where((entry) => entry.value['OwnerID'] == widget.ownerId)
              .map((entry) {
            final saleApartment = Map<String, dynamic>.from(entry.value);
            return Apartment(
              city: saleApartment['city'] as String,
              type: saleApartment['type'] as String,
              price: saleApartment['price'] as int,
              address1: saleApartment['address1'] as String,
            );
          }));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الشقق'),
        centerTitle: true,
        backgroundColor: primaryRed,
      ),
      body: Container(
        color: Colors.white,
        child: _apartments.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _apartments.length,
                itemBuilder: (BuildContext context, int index) {
                  final apartment = _apartments[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            ' المدينة: ${apartment.city}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'العنوان: ${apartment.address1}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'السعر: ${apartment.price}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('تأكيد الحذف'),
                                        content: Text(
                                          'هل أنت متأكد أنك تريد حذف هذه الشقة؟',
                                          textAlign: TextAlign.right,
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text('إلغاء'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('حذف'),
                                            onPressed: () {
                                              // Delete the apartment from Firebase and the list

                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
