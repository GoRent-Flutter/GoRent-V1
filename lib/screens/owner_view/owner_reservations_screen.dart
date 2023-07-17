import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../constraints.dart';
import '../Main/main_screen.dart';
import 'owner_view_screen.dart';

class Reserves {
  final String apartmentcity;
  final String customerName;
  final String date;
  final String time;

  Reserves({
    required this.apartmentcity,
    required this.customerName,
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
              customerName: reservation['customerName'] as String,
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
        centerTitle: true,
        title: Text("الحجوزات"),
        backgroundColor: primaryRed,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OwnerScreen()),
            );
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: _reserves.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _reserves.length,
                itemBuilder: (BuildContext context, int index) {
                  final reservation = _reserves[index];
                  return Card(
                    elevation: 4, // Add elevation for a subtle shadow
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.grey[100], // Change background color
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المدينة: ${reservation.apartmentcity}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'اسم العميل: ${reservation.customerName}',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'التاريخ: ${reservation.date}',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'الوقت: ${reservation.time}',
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
