import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constraints.dart';

class ReserveAppointment extends StatefulWidget {
  @override
  _ReserveAppointmentState createState() => _ReserveAppointmentState();
}

class _ReserveAppointmentState extends State<ReserveAppointment> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

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
          onPressed: () {
            // TODO: Implement reservation logic
          },
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
