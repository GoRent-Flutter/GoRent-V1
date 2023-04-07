import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/SignUp/signup_screen.dart';
import 'package:gorent_application1/screens/users/users_screen.dart';
import '../../constraints.dart';
import '../Main/main_screen.dart';
import '../owner_view/owner_view_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        // child: SizedBox(
        //     width: 100,
        //     height: 100,
            child: Stack(children: <Widget>[
              Positioned(
                  // top: -10,
                  left: 0,
                  right: 0,
                  child: Transform.scale(
                    scale: 1.08,
                    child: Image.asset('assets/icons/GoRent_Logo_Inside.png'),
                  )),
              Positioned(
                top: -40,
                left: -50,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UsersScreen()),
                    );
                  },
                  child: Transform.scale(
                    scale: 0.2,
                    child: Image.asset('assets/icons/White_back.png'),
                  ),
                ),
              ),
              Positioned(
                top: 130,
                left: 25,
                right: 25,
                child: Container(
                  height: size.height * 0.77,
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 180,
                left: 50,
                right: 50,
                child: FittedBox(
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: primaryRed,
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 28,
                          width: 155,
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: primaryWhite,
                            borderRadius: BorderRadius.circular(13.0),
                            border: Border.all(
                              color: primaryRed,
                              width: 1,
                            ),
                          ),
                                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                          child: const Center(
                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: primaryRed,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        ),
                        Container(
                          height: 28,
                          width: 155,
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: primaryRed,
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                     child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                          child: const Center(
                            child: Text(
                              "إنشاء حساب",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: primaryWhite,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 240,
                left: 50,
                right: 50,
                child: Column(
                  children: [
                    Material(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryWhite,
                          borderRadius: BorderRadius.circular(13.0),
                          border: Border.all(
                            color: primaryGrey,
                            width: 1,
                          ),
                        ),
                        
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'البريد الإلكتروني',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: primaryHint,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryWhite,
                          borderRadius: BorderRadius.circular(13.0),
                          border: Border.all(
                            color: primaryGrey,
                            width: 1,
                          ),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: ' كلمة المرور',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: primaryHint,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          textAlign: TextAlign.right,
                          obscureText: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 385,
                left: 60,
                // right: 60,
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(
                      color: primaryLine,
                      fontSize: 14.0,
                      decoration: TextDecoration.none),
                ),
              ),
              Positioned(
                  top: 480,
                  left: 60,
                  right: 60,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
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
                      'تسجيل الدخول - مستخدم',
                      style: TextStyle(
                        color: primaryWhite,
                        fontSize: 21.0,
                      ),
                    ),
                  )),
                   Positioned(
                  top: 550,
                  left: 60,
                  right: 60,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OwnerScreen()),
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
                      'تسجيل الدخول - مالك',
                      style: TextStyle(
                        color: primaryWhite,
                        fontSize: 21.0,
                      ),
                    ),
                  )),
            ]));
  }
}