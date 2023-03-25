import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen.dart';
import 'package:gorent_application1/screens/users/users_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoRent',
      theme: ThemeData(
          primaryColor: primaryRed, scaffoldBackgroundColor: primaryRed),
      home: const UserScreen(),
    );
  }
}
