import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: const [
                      Icon(Icons.add),
                      Text(
                        'اضافة عقار',
                        style: TextStyle(
                          color: primaryRed,
                          fontSize: 21.0,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: primaryRed),
                    ),
                    primary: primaryWhite,
                    onPrimary: primaryRed,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 45, vertical: 45),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Column(
                    children: const [
                      Icon(Icons.home),
                      Text(
                        'عرض عقاراتي',
                        style: TextStyle(
                          color: primaryRed,
                          fontSize: 21.0,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: primaryRed),
                    ),
                    primary: primaryWhite,
                    onPrimary: primaryRed,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 45, vertical: 45),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Column(
                children: const [
                  Icon(Icons.analytics),
                  Text('Analytics'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: primaryRed),
                ),
                primary: primaryWhite,
                onPrimary: primaryRed,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
