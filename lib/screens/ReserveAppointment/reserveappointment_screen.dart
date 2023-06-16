import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constraints.dart';

class ReserveAppointment extends StatefulWidget {
  final String ownerID;
  final String city;
  const ReserveAppointment(
      {Key? key, required this.ownerID, required this.city})
      : super(key: key);
  @override
  _ReserveAppointmentState createState() => _ReserveAppointmentState();
}

class _ReserveAppointmentState extends State<ReserveAppointment> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  late String username;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');
    List<String> parts = sessionId!.split('.');
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userDoc =
        await firestore.collection('customers').doc(parts[1].toString()).get();
    username = userDoc.data()!['fullname'];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

  void _saveReservation() {
    String apartmentOwnerId = widget.ownerID;
    String apartmentcity = widget.city;
    DatabaseReference reservationRef =
        FirebaseDatabase.instance.reference().child('reservations');

    reservationRef.push().set({
      'apartmentOwnerId': apartmentOwnerId,
      'apartmentcity': apartmentcity,
      'custId': username,
      'date': DateFormat('dd/MM/yyyy').format(_selectedDate),
      'time': _selectedTime.format(context),
    }).then((_) {
      Navigator.of(context).pop();
      _showSuccessMessage();
    }).catchError((error) {
      print('error');
    });
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تم ارسال طلب الحجز'),
          content: Text(
              'الحجز الخاص بك قد ارسل الى صاحب العقار, لتفاصيل اكثر بامكانك التواصل معه عبر ايقونة التواصل فوق'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'حجز موعد',
        style: TextStyle(
          color: primaryRed,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ': احجز موعد في الوقت الذي يناسبك',
            style: TextStyle(
              color: primaryRed,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                'تاريخ الحجز: ',
                style: TextStyle(
                  color: primaryRed,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDate),
                  style: TextStyle(
                    color: primaryRed,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'وقت الحجز: ',
                style: TextStyle(
                  color: primaryRed,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () => _selectTime(context),
                child: Text(
                  _selectedTime.format(context),
                  style: TextStyle(
                    color: primaryRed,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: primaryRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'إلغاء',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: primaryRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: _saveReservation,
          child: Text(
            'حجز',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
