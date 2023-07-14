// ignore_for_file: unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
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
    String mergedID = "";
    if (sessionId != null) {
      List<String> parts = sessionId.split('.');
      mergedID = parts[1].toString() + "." + parts[2].toString();
      print('llllllllll' + mergedID);
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userDoc =
          await firestore.collection('customers').doc(mergedID).get();
      username = userDoc.data()!['fullname'];
    }
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
          title: const Text('تم إرسال طلب الحجز'),
          content: const Text(
              'الحجز الخاص بك قد أرسل إلى صاحب العقار، لتفاصيل أكثر بإمكانك التواصل معه عبر ايقونة التواصل في الأعلى'),
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
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'حجز موعد',
        style: TextStyle(
          color: primaryRed,
          fontSize: 20,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            ': احجز موعد في الوقت الذي يناسبك',
            style: TextStyle(
              color: primaryRed,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
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
                  style: const TextStyle(
                    color: primaryRed,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
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
                  style: const TextStyle(
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
          child: const Text(
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
          child: const Text(
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
