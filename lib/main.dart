import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/ContactOwner/ContactOwner.dart';
import 'package:gorent_application1/splash_screen.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen_customer.dart';
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
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 1)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return UsersScreen();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
