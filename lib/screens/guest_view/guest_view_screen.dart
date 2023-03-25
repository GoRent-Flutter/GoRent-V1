import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';

class GuestScreen extends StatelessWidget {
  const GuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تم تسجيل الدخول كزائر',
          style: TextStyle(
            color: primaryRed,
            fontSize: 21.0,
          ),
        ),
        backgroundColor: primaryGrey,
      ),
      backgroundColor: primaryWhite,
    );
  }
}
