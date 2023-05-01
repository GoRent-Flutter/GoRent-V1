import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Login/login_screen.dart';
import 'package:gorent_application1/screens/SignUp/signup_screen.dart';
import 'package:gorent_application1/screens/guest_view/guest_view_screen.dart';
import '../../constraints.dart';
import '../users/users_screen.dart';

class WelcomeScreenCustomer extends StatelessWidget {
  const WelcomeScreenCustomer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double imageHeight = size.height * 0.8;
    double firstButtonTop =
        imageHeight - 170.0; // set to height of image plus margin

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
                  secondGradient,
                  primaryRed,
                ],
              ),
            ),
            child: Stack(children: [
              Positioned(
                top: -15,
                left: -20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UsersScreen()),
                    );
                  },
                  child: Transform.scale(
                    scale: 0.15,
                    child: Image.asset('assets/icons/White_back1.png'),
                  ),
                ),
              ),
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
                child: Image.asset('assets/images/welcomeImg.png',
                    width: size.width * 0.8, height: imageHeight),
              ),
              Positioned(
                  top: firstButtonTop,
                  left: 60,
                  right: 60,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen(
                                  currentIndex: 1,
                                )),
                      );
                    },
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
                top: firstButtonTop +
                    80.0, // add vertical spacing between buttons
                left: 60,
                right: 60,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryRed,
                        secondGradient,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(37.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(currentIndex: 1)),
                      );
                    },
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1, color: primaryWhite),
                      backgroundColor: Colors.transparent,
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
                  ),
                ),
              ),
              Positioned(
                  top: firstButtonTop +
                      160.0, // add vertical spacing between buttons
                  left: 60,
                  right: 60,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GuestScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryPale,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(37.0),
                      ),
                    ),
                    child: const Text(
                      'تصفح التطبيق كزائر',
                      style: TextStyle(
                        color: primaryWhite,
                        fontSize: 21.0,
                      ),
                    ),
                  ))
            ])));
  }
}
