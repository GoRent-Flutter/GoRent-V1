import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen.dart';
import 'package:gorent_application1/screens/owner_view/owner_view_screen.dart';
import '../../constraints.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryRed, // set background color to red
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300, // <-- match_parent
              height: 100, //
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OwnerScreen()),
                  );
                },
                child: const Text(
                  'اضغط هنا لعرض تفاصيل الشقة وتسجيل العرض الخاص بك',
                  style: TextStyle(
                    color: primaryWhite,
                    fontSize: 21.0,
                  ),
                ),
                style: TextButton.styleFrom(
                  side: const BorderSide(width: 1, color: primaryWhite),
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 300, // <-- match_parent
              height: 100, //
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomeScreen()),
                  );
                },
                child: const Text(
                  'اضغط هنا للاطلاع على تفاصيل الشقة والحجز',
                  style: TextStyle(
                    color: primaryWhite,
                    fontSize: 21.0,
                  ),
                ),
                style: TextButton.styleFrom(
                  side: const BorderSide(width: 1, color: primaryWhite),
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
