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
          padding: const EdgeInsets.only(top: 100), // adjust the top padding as necessary
          child: Column(
            children: [
              const Text(
                'Apartment added successfully!',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: SizedBox(),
              ),
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
                    ),
                    child: const Text('Continue Uploading'),
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
                    ),
                    child: const Text('Stop Uploading'),
                  ),
                ],
              ),
              SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
