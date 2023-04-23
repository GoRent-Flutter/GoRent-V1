import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/owner_view/add_appartment.dart';

import '../../owner_bottom_nav_bar.dart';
import '../users/users_screen.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
     
      child: Stack(
        children: [
          Positioned(child: Scaffold( bottomNavigationBar: const OwnerBottomNavBar(currentIndex: 0,),)),
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
                child: Image.asset('assets/icons/Red_back.png'),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
