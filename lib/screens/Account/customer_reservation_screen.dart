import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../constraints.dart';
import 'user_account_screen.dart';

class Reserves {
  final String apartmentcity;
  final String ownerName;
  final String date;
  final String time;
  final bool isPending;
  final bool isApproved;

  Reserves({
    required this.apartmentcity,
    required this.ownerName,
    required this.date,
    required this.time,
    this.isApproved = false,
    this.isPending = true,
  });
}

class CustomerReservationsScreen extends StatefulWidget {
  final String customerId;
  final int currentIndex;

  CustomerReservationsScreen(
      {required this.customerId, required this.currentIndex});

  @override
  _CustomerReservationsScreenState createState() =>
      _CustomerReservationsScreenState();
}

class _CustomerReservationsScreenState
    extends State<CustomerReservationsScreen> {
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
              .where((entry) => entry.value['custId'] == widget.customerId)
              .map((entry) {
            final reservation = Map<String, dynamic>.from(entry.value);
            return Reserves(
              apartmentcity: reservation['apartmentcity'] as String,
              ownerName: reservation['ownerName'] as String,
              date: reservation['date'] as String,
              time: reservation['time'] as String,
              isApproved: reservation['isApproved'] as bool,
              isPending: reservation['isPending'] as bool,
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
              MaterialPageRoute(
                  builder: (context) => UserAccountScreen(
                        currentIndex: widget.currentIndex,
                      )),
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
                              'اسم المالك: ${reservation.ownerName}',
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
                            if (reservation.isPending)
                              Text(
                                'طلبك قيد المراجعة',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              )
                            else if (reservation.isApproved)
                              Text(
                                'تم الموافقة على الحجز',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              )
                            else
                              Text(
                                'تم رفض الحجز',
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
