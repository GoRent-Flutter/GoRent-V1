import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Models_Folder/CustModel.dart';
import 'package:gorent_application1/screens/Models_Folder/OwnerModel.dart';
import 'package:gorent_application1/screens/SignUp/signup_screen.dart';
import 'package:gorent_application1/screens/users/users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../constraints.dart';
import '../Main/main_screen.dart';
import '../owner_view/owner_view_screen.dart';
import 'ResetPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  final int currentIndex;

  LoginScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorText;

  Future<void> checkValues(BuildContext context) async {
    setState(() {
      errorText = null; // Reset error text
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorText = 'Please fill in all fields';
      });
      return;
    }

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      if (widget.currentIndex == 1) {
        String userId =
            email + "-GRCU"; // Use email as user ID -- GO RENT CUSTOMER
        // Check if owner already exists in collection
        final userDoc =
            await firestore.collection('customers').doc(userId).get();
        if (userDoc.exists) {
          // Check if password matches
          bool crackedPassword =
              BCrypt.checkpw(password, userDoc.data()!['password']);
          if (crackedPassword) {
            // Generate and store session ID
            String sessionId = Uuid().v4();
            // Distinguish between customer and owner session ID
            String userSessionId = sessionId + "." + userId;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('sessionId', userSessionId);
            print('SESSION ID: ' + userSessionId);

            CustModel custModel =
                CustModel.fromMap(userDoc.data() as Map<String, dynamic>);

            Navigator.pop(context);
          } else {
            setState(() {
              errorText = 'Incorrect password';
            });
          }
        } else {
          setState(() {
            errorText = 'User does not exist';
          });
        }
      } else if (widget.currentIndex == 0) {
        String userId = email + "-GROW"; // Use email as user ID --GO RENT OWNER
        // Check if owner already exists in collection
        final userDoc = await firestore.collection('owners').doc(userId).get();
        if (userDoc.exists) {
          // Check if password matches
          bool crackedPassword =
              BCrypt.checkpw(password, userDoc.data()!['password']);
          if (crackedPassword) {
            // Generate and store session ID
            String sessionId = Uuid().v4();
            // Distinguish between customer and owner session ID
            String userSessionId = sessionId + "." + userId;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('sessionId', userSessionId);
            print('SESSION ID: ' + userSessionId);

            OwnerModel ownerModel =
                OwnerModel.fromMap(userDoc.data() as Map<String, dynamic>);

            Navigator.pop(context);
          } else {
            setState(() {
              errorText = 'Incorrect password';
            });
          }
        } else {
          setState(() {
            errorText = 'User does not exist';
          });
        }
      }
    } catch (ex) {
      print(ex.toString());
      setState(() {
        errorText = 'An error occurred while trying to sign in';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        child: Stack(children: <Widget>[
          Positioned(
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
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const UsersScreen(),
                  ),
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
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      LoginScreen(
                                currentIndex: widget.currentIndex,
                              ),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryRed,
                              decoration: TextDecoration.none,
                            ),
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
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SignupScreen(
                                currentIndex: widget.currentIndex,
                              ),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            "إنشاء حساب",
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryWhite,
                              decoration: TextDecoration.none,
                            ),
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
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryWhite,
                      border: Border.all(
                        color: primaryGrey,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'البريد الإلكتروني',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: primaryHint,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        errorText: errorText,
                      ),
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Material(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryWhite,
                      border: Border.all(
                        color: primaryGrey,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: ' كلمة المرور',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: primaryHint,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        errorText: errorText,
                        errorStyle: TextStyle(
                          color: Colors.red,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                      obscureText: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 390,
            left: 60,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => ForgetPasswordScreen(),
                );
              },
              child: const Text(
                'نسيت كلمة المرور؟',
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  color: primaryLine,
                  fontSize: 14.0,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Positioned(
              top: 480,
              left: 60,
              right: 60,
              child: TextButton(
                onPressed: () async {
                  await checkValues(context);
                  if (errorText == null) {
                    widget.currentIndex == 1
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(currentIndex: 1),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OwnerScreen(),
                            ),
                          );
                  }
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
        ]));
  }
}
