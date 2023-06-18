import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class apartment {
  final String city;
  final String type;
  final int price;

  apartment({
    required this.city,
    required this.type,
    required this.price,
  });
}

class Myapartment extends apartment {
  final String city;
  final String type;
  final int price;

  Myapartment({
    required this.city,
    required this.type,
    required this.price,
  }) : super(city: city, type: type, price: price);
}

class Myapartment2 extends apartment {
  final String city;
  final String type;
  final int price;

  Myapartment2({
    required this.city,
    required this.type,
    required this.price,
  }) : super(city: city, type: type, price: price);
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
  List<Myapartment> _Myapartment = [];
  List<Myapartment2> _Myapartment2 = [];
  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.reference().child('rent');
    _databaseRef2 = FirebaseDatabase.instance.reference().child('sale');
    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final rentmyapartment = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          _Myapartment = rentmyapartment.entries
              .where((entry) => entry.value['OwnerID'] == widget.ownerId)
              .map((entry) {
            final rentedapartment = Map<String, dynamic>.from(entry.value);
            return Myapartment(
              city: rentedapartment['city'] as String,
              type: rentedapartment['type'] as String,
              price: rentedapartment['price'] as int,
            );
          }).toList();
        });
      }
    });
    _databaseRef2.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final salemyapartment = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          _Myapartment2 = salemyapartment.entries
              .where((entry) => entry.value['OwnerID'] == widget.ownerId)
              .map((entry) {
            final saleapartment = Map<String, dynamic>.from(entry.value);
            return Myapartment2(
              city: saleapartment['city'] as String,
              type: saleapartment['type'] as String,
              price: saleapartment['price'] as int,
            );
          }).toList();
        });
      }
    });
  }

  List<apartment> _combineApartments() {
    List<apartment> combinedList = [];
    combinedList.addAll(_Myapartment);
    combinedList.addAll(_Myapartment2);
    return combinedList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reservations'),
        ),
        body: ListView.builder(
          itemCount: _combineApartments().length,
          itemBuilder: (BuildContext context, int index) {
            final apart = _combineApartments()[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  'Apartment City: ${apart.city}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'type: ${apart.type}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'price: ${apart.price}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}