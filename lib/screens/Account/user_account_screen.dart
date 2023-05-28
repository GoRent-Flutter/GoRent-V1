import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Account/report_problem/report_problem_screen.dart';
import 'package:gorent_application1/screens/Account/userdetails/user_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../guest_bottom_nav.dart';
import '../../owner_bottom_nav_bar.dart';
import '../../user_bottom_nav_bar.dart';
import 'notification/notification_screen.dart';
String username = "";
void fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final sessionId = prefs.getString('sessionId');
  List<String> parts = sessionId!.split('.');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final userDoc =
      await firestore.collection('customers').doc(parts[1].toString()).get();
  username = userDoc.data()!['fullname'];
}

class UserAccountScreen extends StatelessWidget {
  final int currentIndex;
  const UserAccountScreen({Key? key,required this.currentIndex}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
      // fetchUserData();
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      child: SizedBox(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Scaffold(
                bottomNavigationBar: currentIndex == 1
                ? const BottomNavBar(
                    currentIndex: 3,
                  )
                    :currentIndex == 0? const OwnerBottomNavBar(
                        currentIndex: 3,
                      )
                    : const GuestBottomNavBar(
                        currentIndex: 3,
                      ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 80, left: 230, bottom: 50),
                  child: Text(
                    "حسابي الشخصي",
                    style: TextStyle(
                      fontFamily: 'Scheherazade_New',
                      fontSize: 22,
                      color: primaryRed,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePageState(currentIndex:currentIndex),)
                      );
                    },
                    child: Container(
                      height: 110,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            "اسم المستخدم",
                            style: TextStyle(
                              fontFamily: 'Scheherazade_New',
                              fontSize: 20,
                              color: primaryRed,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Image.asset(
                            'assets/images/user.png',
                            width: 150,
                            height: 100,
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 22, color: primaryRed),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 30),
                    child: Column(
                      children: [
                        _buildButtonWithDivider(
                          context, // pass context as a parameter
                          "assets/images/notification.png",
                          "الاشعارات",
                          const NotificationsPage(),
                        ),
                        _buildButtonWithDivider(
                          context, // pass context as a parameter
                          "assets/images/reportProblem.png",
                          "الابلاغ عن مشكلة",
                          ReportProblemScreen(currentIndex:currentIndex,),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWithDivider(
    BuildContext context, // add BuildContext as a parameter
    String imagePath,
    String text,
    Widget screen,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => screen),
            );
          },
          child: Container(
            height: 60,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Image.asset(
                    imagePath,
                    width: 50,
                    height: 50,
                  ),
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontFamily: 'Scheherazade_New',
                    fontSize: 18,
                    color: primaryRed,
                    decoration: TextDecoration.none,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios,
                    size: 22, color: primaryRed),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.grey[300],
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}
