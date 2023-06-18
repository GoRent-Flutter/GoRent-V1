import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Reserves {
  final String apartmentcity;
  final String custId;
  final String date;
  final String time;

  Reserves({
    required this.apartmentcity,
    required this.custId,
    required this.date,
    required this.time,
  });
}

class OwnerReservationsScreen extends StatefulWidget {
  final String ownerId;

  OwnerReservationsScreen({required this.ownerId});

  @override
  _OwnerReservationsScreenState createState() =>
      _OwnerReservationsScreenState();
}

class _OwnerReservationsScreenState extends State<OwnerReservationsScreen> {
  late DatabaseReference _databaseRef;
  List<Reserves> _reserves = [];
  @override
  void initState() {
    super.initState();
    _databaseRef = FirebaseDatabase.instance.reference().child('reservations');
    _databaseRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final reservations = (event.snapshot.value as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
        setState(() {
          _reserves = reservations.entries
              .where(
                  (entry) => entry.value['apartmentOwnerId'] == widget.ownerId)
              .map((entry) {
            final reservation = Map<String, dynamic>.from(entry.value);
            return Reserves(
              apartmentcity: reservation['apartmentcity'] as String,
              custId: reservation['custId'] as String,
              date: reservation['date'] as String,
              time: reservation['time'] as String,
            );
          }).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reservations'),
        ),
        body: ListView.builder(
          itemCount: _reserves.length,
          itemBuilder: (BuildContext context, int index) {
            final reservation = _reserves[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  'Apartment City: ${reservation.apartmentcity}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Customer ID: ${reservation.custId}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Date: ${reservation.date}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Time: ${reservation.time}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
