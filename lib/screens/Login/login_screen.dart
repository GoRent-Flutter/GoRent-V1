import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Models_Folder/UserModel.dart';
import 'package:gorent_application1/screens/SignUp/signup_screen.dart';
import 'package:gorent_application1/screens/users/users_screen.dart';
import '../../constraints.dart';
import '../Main/main_screen.dart';
import '../owner_view/owner_view_screen.dart';

class LoginScreen extends StatelessWidget {
  final int currentIndex;
  static bool isOwner = false;
  static bool isUser = false;

  LoginScreen({Key? key, required this.currentIndex}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> checkValues(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      //a text should appear to the user/owner (will do this later)
      print("fill the empty fields!");
      return false;
    } else {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      try {
        String userId = email; // Use email as user ID

        if (currentIndex == 1) {
          // Check if customer already exists in collection
          final userDoc =
              await firestore.collection('customers').doc(userId).get();
          if (userDoc.exists) {
            print('User already exists in collection');
            // Check if password matches
            if (userDoc.data()!['password'] == password) {
              Navigator.pop(context);
              return true;
            } else {
              print('Incorrect password');
              return false;
            }
          } else {
            print('User does not exist in collection');
            return false;
          }
        } else if (currentIndex == 0) {
          // Check if owner already exists in collection
          final userDoc =
              await firestore.collection('owners').doc(userId).get();
          if (userDoc.exists) {
            print('User already exists in collection');
            // Check if password matches
            if (userDoc.data()!['password'] == password) {
              Navigator.pop(context);
              return true;
            } else {
              print('Incorrect password');
              return false;
            }
          } else {
            print('User does not exist in collection');
            return false;
          }
        }
      } catch (ex) {
        print(ex.toString());
        return false;
      }
    }
    return false; // def return value
  }

  // Future<void> signIn(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );
  //   await Future.delayed(const Duration(seconds: 1)); // Add delay here
  //   Navigator.pop(context);
  // }

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
                                builder: (context) => LoginScreen(
                                      currentIndex: currentIndex,
                                    )),
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
                                builder: (context) => SignupScreen(
                                      currentIndex: currentIndex,
                                    )),
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
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryWhite,
                      // borderRadius: BorderRadius.circular(13.0),
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
                      // borderRadius: BorderRadius.circular(13.0),
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
          const Positioned(
            top: 390,
            left: 60,
            // right: 60,
            child: Text(
              'نسيت كلمة المرور؟',
              style: TextStyle(
                fontFamily: 'Scheherazade_New',
                color: primaryLine,
                fontSize: 14.0,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Positioned(
              top: 480,
              left: 60,
              right: 60,
              child: TextButton(
                onPressed: () async {
                  // await signIn(context);
                  bool success = await checkValues(context);
                  if (success == true) {
                    currentIndex == 1
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OwnerScreen()),
                          );
                  } else if (success == false) {
                    print("an error occurred while trying to sign up");
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
