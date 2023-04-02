import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Account/report_problem/report_problem_screen.dart';
import 'package:gorent_application1/screens/Account/userdetails/user_details_screen.dart';

import 'location/location_screen.dart';
import 'notification/notification_screen.dart';

class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        
       crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 80, left: 230, bottom: 50),
            child: Text(
              "حسابي الشخصي",
              style: TextStyle(
                fontSize: 22,
                color: primaryRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilePageState()),
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
                    const Text(
                      "اسم المستخدم",
                      style: TextStyle(
                        fontSize: 20,
                        color: primaryRed,
                        fontWeight: FontWeight.bold,
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
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 30),
              child: Column(
                children: [
                  _buildButtonWithDivider(
                    context, // pass context as a parameter
                    "assets/images/notificcation.png",
                    "الاشعارات",
                    const NotificationsPage(),
                  ),
                  _buildButtonWithDivider(
                    context, // pass context as a parameter
                    "assets/images/location.png",
                    "الموقع",
                    const LocationPage(),
                  ),
                  _buildButtonWithDivider(
                    context, // pass context as a parameter
                    "assets/images/problem.png",
                    "الابلاغ عن مشكلة",
                    const ReportProblemPage(),
                  ),
                ],
              ),
            ),
          ),
        ],
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
                    width: 60,
                    height: 60,
                  ),
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 22,
                    color: primaryRed,
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
