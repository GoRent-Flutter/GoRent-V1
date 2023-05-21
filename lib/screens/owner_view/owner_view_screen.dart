import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/owner_view/add_appartment.dart';
import '../../owner_bottom_nav_bar.dart';
import '../users/users_screen.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.4;
    final double buttonHeight = 100.0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white70,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            child: Scaffold(
              bottomNavigationBar: const OwnerBottomNavBar(currentIndex: 0,),
            ),
          ),
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
          Align(
            alignment: Alignment(-0.9, -0.8),
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.9, 0.8),
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
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
                    buildButton(
                      buttonWidth: buttonWidth,
                      buttonHeight: buttonHeight,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddApartmentScreen()),
                        );
                      },
                      icon: Icons.add,
                      text: 'اضافة عقار',
                    ),
                    buildButton(
                      buttonWidth: buttonWidth,
                      buttonHeight: buttonHeight,
                      onPressed: () {},
                      icon: Icons.home,
                      text: 'عرض عقاراتي',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildButton(
                  buttonWidth: buttonWidth,
                  buttonHeight: buttonHeight,
                  onPressed: () {},
                  icon: Icons.analytics,
                  text: 'Analytics',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton buildButton({
    required double buttonWidth,
    required double buttonHeight,
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Text(
            text,
            style: const TextStyle(
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
        padding: EdgeInsets.symmetric(horizontal: buttonWidth / 4, vertical: buttonHeight / 4),
      ),
    );
  }
}
