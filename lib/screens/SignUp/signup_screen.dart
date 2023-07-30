import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Login/login_screen.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:gorent_application1/screens/Models_Folder/CustModel.dart';
import 'package:gorent_application1/screens/Models_Folder/OwnerModel.dart';
import 'package:gorent_application1/screens/owner_view/owner_view_screen.dart';
import 'package:gorent_application1/screens/users/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../constraints.dart';
import 'about_you_screen.dart';

class SignupScreen extends StatelessWidget {
  final int currentIndex;
  static String passedUserId = 'user';
  SignupScreen({Key? key, required this.currentIndex}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<bool> checkValues() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if (email == "" || password == "" || confirmPassword == "") {
      //a text should appear to the user/owner (will do this later)
      print("fill the empty fields!");
      return false;
    } else if (password != confirmPassword) {
      //a text should appear to the user/owner (will do this later)
      print("password doesn't match!");
      return false;
    } else {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      try {
        if (currentIndex == 1) {
          String userId =
              email + "-GRCU"; // Use email as user ID -- GO RENT CUSTOMER

          // Check if customer already exists in collection
          final userDoc =
              await firestore.collection('customers').doc(userId).get();
          if (userDoc.exists) {
            print('User already exists in collection');
            return false;
          }
          // if the customer does not exist, add new user to collection
          else {
            String hashedPassword =
                BCrypt.hashpw(passwordController.text, BCrypt.gensalt());
            CustModel newCustomer = CustModel(
                custId: userId,
                phone_number: null,
                email: email.toLowerCase(),
                password: hashedPassword,
                city: null,
                fullname: null);
            await firestore
                .collection('customers')
                .doc(userId)
                .set(newCustomer.toMap());
            passedUserId = userId;

            return true;
          }
        } else if (currentIndex == 0) {
          String userId =
              email + "-GROW"; // Use email as user ID -- GO RENT OWNER

          // Check if owner already exists in collection
          final userDoc =
              await firestore.collection('owners').doc(userId).get();
          if (userDoc.exists) {
            print('User already exists in collection');
            return false;
          }
          // if the owner does not exist, add new user to collection
          else {
            String hashedPassword =
                BCrypt.hashpw(passwordController.text, BCrypt.gensalt());
            OwnerModel newOwner = OwnerModel(
                ownerId: userId,
                phone_number: null,
                email: email,
                password: hashedPassword,
                city: null,
                fullname: null);
            await firestore
                .collection('owners')
                .doc(userId)
                .set(newOwner.toMap());
            passedUserId = userId;
            return true;
          }
        }
      } catch (ex) {
        print(ex.toString());
        return false;
      }
    }
    return false; // def return value
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        child: SizedBox(
            width: 100,
            height: 100,
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
                      MaterialPageRoute(
                          builder: (context) => const UsersScreen()),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset(0.0, 0.0);
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return LoginScreen(
                                    currentIndex: currentIndex,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 28,
                            width: 155,
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                              color: primaryRed,
                              borderRadius: BorderRadius.circular(13.0),
                              border: Border.all(
                                color: primaryRed,
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "تسجيل الدخول",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryWhite,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset(0.0, 0.0);
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return SignupScreen(
                                    currentIndex: currentIndex,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
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
                            child: const Center(
                              child: Text(
                                "إنشاء حساب",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryRed,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        )
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
                            hintText: ' ادخل البريد الإلكتروني',
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
                            hintText: 'ادخل كلمة المرور',
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
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: 'تأكيد كلمة المرور',
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
              Positioned(
                top: 480,
                left: 60,
                right: 60,
                child: TextButton(
                  onPressed: () async {
                    bool success = await checkValues();
                    if (success == true) {
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return AboutYouScreen(
                              userId: passedUserId,
                              currentIndex: currentIndex,
                            );
                          },
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
                  child: const Center(
                    child: Text(
                      'انشاء حساب',
                      style: TextStyle(
                        fontSize: 21.0,
                        color: primaryWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ])));
  }
}
