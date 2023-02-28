import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Login/login_screen.dart';
import 'package:gorent_application1/screens/SignUp/signup_screen.dart';

import '../../constraints.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: [
      Positioned(
        top: -150,
        left: 50,
        right: 50,
        child: Image.asset('assets/images/GoRent.png',
            width: size.width * 0.6, height: size.height * 0.6),
      ),
      Positioned(
        top: -30,
        left: 50,
        right: 50,
        child: Image.asset('assets/images/welcomeImg.jpg',
            width: size.width * 0.8, height: size.height * 0.8),
      ),
      Positioned(
          top: 450,
          left: 60,
          right: 60,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const SignupScreen()),
              );            },
            style: TextButton.styleFrom(
              backgroundColor: primaryWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(37.0),
              ),
            ),
            child: const Text(
              'إنشاء حساب',
              style: TextStyle(
                color: primaryRed,
                fontSize: 21.0,
              ),
            ),
          )),
      Positioned(
          top: 530,
          left: 60,
          right: 60,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const LoginScreen()),
              );
            },
            style: TextButton.styleFrom(
              side: const BorderSide(width: 1, color: primaryWhite),
              backgroundColor: primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(37.0),
              ),
            ),
            child: const Text(
              'تسجيل الدخول',
              style: TextStyle(
                color: primaryWhite,
                fontSize: 21.0,
              ),
            ),
          )),
      Positioned(
          top: 610,
          left: 60,
          right: 60,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: primaryPale,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(37.0),
              ),
            ),
            child: const Text(
              'الإستخدام من جهة مالك العقار',
              style: TextStyle(
                color: primaryWhite,
                fontSize: 21.0,
              ),
            ),
          ))
    ]));
  }
}
