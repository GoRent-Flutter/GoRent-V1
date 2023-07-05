import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen_customer.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen_owner.dart';
import 'package:flutter/services.dart';

import '../../constraints.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset('assets/images/GoRent.png', height: 150),
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        primaryRed,
                        secondGradientButton,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const WelcomeScreenCustomer(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(1.0, 0.0);
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
                    child: const Text(
                      'اضغط هنا للاستخدام كمشتري',
                      style: TextStyle(
                        color: primaryWhite,
                        fontSize: 21.0,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1, color: primaryWhite),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        primaryRed,
                        secondGradientButton,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const WelcomeScreenOwner(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(-1.0, 0.0);
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
                    child: const Text(
                      'اضغط هنا للاستخدام كبائع',
                      style: TextStyle(
                        color: primaryWhite,
                        fontSize: 21.0,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1, color: primaryWhite),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
