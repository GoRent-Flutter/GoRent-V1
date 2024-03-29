import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Login/login_screen.dart';
import 'package:gorent_application1/screens/SignUp/signup_screen.dart';
import '../../constraints.dart';
import '../users/users_screen.dart';

class WelcomeScreenOwner extends StatelessWidget {
  const WelcomeScreenOwner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double imageHeight = size.height * 0.8;
    double firstButtonTop =
        imageHeight - 170.0; // set to height of image plus margin

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              secondGradient,
              primaryRed,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -15,
              left: -20,
              child: GestureDetector(
                onTap: () {
                  // Replace the current route instead of pushing a new one
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const UsersScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(-1.0, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
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
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SignupScreen(currentIndex: 0),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(1.0, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(width: 1, color: primaryWhite),
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
              ),
            ),
            Positioned(
              top:
                  firstButtonTop + 80.0, // add vertical spacing between buttons
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
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LoginScreen(currentIndex: 0),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
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
          ],
        ),
      ),
    );
  }
}
