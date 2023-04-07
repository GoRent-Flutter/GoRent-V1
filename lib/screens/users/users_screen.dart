import 'package:flutter/material.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen_customer.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen_owner.dart';
import 'package:gorent_application1/screens/owner_view/owner_view_screen.dart';
import '../../constraints.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryRed,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset('assets/images/GoRent.png', height: 150),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreenCustomer(),
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
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreenOwner(),
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
