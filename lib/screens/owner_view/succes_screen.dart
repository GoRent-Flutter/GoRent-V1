import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/owner_view/add_appartment.dart';
import 'package:gorent_application1/screens/owner_view/owner_view_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'تمت إضافة الشقة بنجاح!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Icon(
                Icons.sentiment_satisfied, // Smiley face icon
                size: 150,
                color: primaryRed, // Changed color to red
              ),
              SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddApartmentScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(160, 50), // Increased button size
                    ),
                    child: const Text(
                      'متابعة التحميل',
                      style: TextStyle(fontSize: 16), // Increased text size
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OwnerScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(160, 50), // Increased button size
                    ),
                    child: const Text(
                      'إيقاف التحميل',
                      style: TextStyle(fontSize: 16), // Increased text size
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
}
