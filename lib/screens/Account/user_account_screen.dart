import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Account/report_problem/report_problem_screen.dart';
import 'package:gorent_application1/screens/Account/userdetails/user_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../guest_bottom_nav.dart';
import '../../owner_bottom_nav_bar.dart';
import '../../user_bottom_nav_bar.dart';
import '../Users/users_screen.dart';
import 'customer_reservation_screen.dart';

class UserAccountScreen extends StatefulWidget {
  final int currentIndex;

  const UserAccountScreen({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  _UserAccountScreenState createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  String username = " ";
  String customerId = "";
  String owenerId = "";
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');

    String mergedID = "";
    if (sessionId != null) {
      List<String> parts = sessionId.split('.');
      mergedID = parts[1].toString() + "." + parts[2].toString();
      print('llllllllll' + mergedID);
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userDoc;
      if (parts[2].toString().contains("GRCU")) {
        userDoc = await firestore.collection('customers').doc(mergedID).get();
        customerId = userDoc.data()!['custId'];
      } else {
        userDoc = await firestore.collection('owners').doc(mergedID).get();
        owenerId = userDoc.data()!['ownerId'];
      }
      setState(() {
        username = userDoc.data()!['fullname'];
      });
    } else {
      setState(() {
        username = " ";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('sessionId');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersScreen()),
                );
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: primaryRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: SizedBox(
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Scaffold(
                  bottomNavigationBar: widget.currentIndex == 1
                      ? const BottomNavBar(
                          currentIndex: 3,
                        )
                      : widget.currentIndex == 0
                          ? const OwnerBottomNavBar(
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
                            builder: (context) => EditProfilePageState(
                                currentIndex: widget.currentIndex),
                          ),
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
                              username, // Show the fetched username here
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 30),
                      child: Column(
                        children: [
                          // _buildButtonWithDivider(
                          //   context,
                          //   "assets/images/notification.png",
                          //   "الاشعارات",
                          // ),
                          _buildButtonWithDivider(
                            context,
                            "assets/images/reportProblem.png",
                            "الابلاغ عن مشكلة",
                          ),
                          _buildButtonWithDivider(
                            context,
                            "assets/images/bookings.png",
                            "الحجوزات",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWithDivider(
    BuildContext context,
    String imagePath,
    String text,
  ) {
    if (text == "الحجوزات" && owenerId.isNotEmpty) {
      // If the user is an owner, return an empty container to hide the button
      return Container();
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (text == "الاشعارات") {
              AppSettings.openNotificationSettings();
            } else if (text == "الابلاغ عن مشكلة") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ReportProblemScreen(currentIndex: widget.currentIndex),
                ),
              );
            } else if (text == "الحجوزات") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerReservationsScreen(
                    customerId: customerId,
                    currentIndex: widget.currentIndex,
                  ),
                ),
              );
            }
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
