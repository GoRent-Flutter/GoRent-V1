import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../constraints.dart';
import '../Main/main_screen.dart';
import 'owner_view_screen.dart';

class Reserves {
  final String reservationId;
  final String apartmentcity;
  final String customerName;
  final String date;
  final String time;
  bool isPending;
  bool isApproved;

  Reserves({
    required this.reservationId,
    required this.apartmentcity,
    required this.customerName,
    required this.date,
    required this.time,
    this.isApproved = false,
    this.isPending = true,
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
              reservationId:
                  entry.key, // Pass the reservationId to the constructor
              apartmentcity: reservation['apartmentcity'] as String,
              customerName: reservation['customerName'] as String,
              date: reservation['date'] as String,
              time: reservation['time'] as String,
              isApproved: reservation['isApproved'] as bool,
            );
          }).toList();
        });
      }
    });
  }

  // Function to update the approval status in Firebase
  void updateReservationApprovalStatus(String reservationId, bool isApproved) {
    DatabaseReference reservationRef =
        FirebaseDatabase.instance.reference().child('reservations');

    reservationRef.child(reservationId).update({
      'isApproved': isApproved,
      'isPending': false,
    }).then((_) {
      // Do something after successful update, if needed.
    }).catchError((error) {
      print('Error updating approval status: $error');
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
                    elevation: 4,
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.grey[100],
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
                            SizedBox(height: 16),
                            if (reservation.isApproved)
                              Text(
                                'تم الموافقة على الحجز',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              )
                            else if (reservation.isPending)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _reserves[index].isApproved = true;
                                      });
                                      updateReservationApprovalStatus(
                                          reservation.reservationId,
                                          true); // Update approval status in Firebase
                                    },
                                    child: Text(
                                      'قبول',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _reserves[index].isApproved = false;
                                        _reserves[index].isPending =
                                            false; // Set isPending to false when rejecting the reservation
                                      });
                                      updateReservationApprovalStatus(
                                        reservation.reservationId,
                                        false,
                                      ); // Update approval status in Firebase
                                    },
                                    child: Text(
                                      'رفض',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                'لقد قمت برفض الحجز',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
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
