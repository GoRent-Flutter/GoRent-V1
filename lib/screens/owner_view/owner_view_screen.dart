import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/ContactOwner/Chatting_System/chats_screen.dart';
import 'package:gorent_application1/screens/owner_view/add_appartment.dart';
import '../../owner_bottom_nav_bar.dart';
import '../users/users_screen.dart';
import 'owner_reservations_screen.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.4;
    final double buttonHeight = 100.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.white70,
          ],
        ),
      ),
      child: Stack(children: [
        const Positioned(
          child: Scaffold(
            bottomNavigationBar: OwnerBottomNavBar(
              currentIndex: 0,
            ),
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
          alignment: const Alignment(-0.9, -0.8),
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
          alignment: const Alignment(0.9, 0.8),
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
                    context: context,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('اختر طريقة الإضافة'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddApartmentScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: primaryRed,
                                    minimumSize:
                                        const Size(double.infinity, 60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'إضافة يدوية',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => const UploadCsvScreen()),
                                    // );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: primaryRed,
                                    minimumSize:
                                        const Size(double.infinity, 60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'تحميل من ملف CSV',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icons.add,
                    text: 'اضافة عقار',
                  ),
                  buildButton(
                    buttonWidth: buttonWidth,
                    buttonHeight: buttonHeight,
                    context: context,
                    onPressed: () {},
                    icon: Icons.home,
                    text: 'عرض عقاراتي',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildButton(
                          buttonWidth: buttonWidth,
                          buttonHeight: buttonHeight,
                          context: context,
                          onPressed: () {},
                          icon: Icons.analytics,
                          text: 'Analytics',
                        ),
                        buildButton(
                          buttonWidth: buttonWidth,
                          buttonHeight: buttonHeight,
                          context: context,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OwnerReservationsScreen(
                                  ownerId: "Aqark@gmail.com-GROW",
                                ),
                              ),
                            );
                          },
                          icon: Icons.analytics,
                          text: 'Reservations',
                        ),
                        const SizedBox(width: 10.0),
                        buildButton(
                          buttonWidth: buttonWidth,
                          buttonHeight: buttonHeight,
                          context: context,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatsScreen()),
                            );
                          },
                          icon: Icons.message,
                          text: 'Messages',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

ElevatedButton buildButton({
  required double buttonWidth,
  required double buttonHeight,
  required BuildContext context,
  required IconData icon,
  required String text,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 32, // Increased icon size
          color: primaryRed, // Use primaryRed color for the icon
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: primaryRed,
            fontSize: 18.0, // Increased text size
          ),
          textAlign: TextAlign.center,
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
      padding: EdgeInsets.symmetric(
          horizontal: buttonWidth / 4, vertical: buttonHeight / 4),
      minimumSize:
          Size(buttonWidth, buttonHeight), // Set the same size for the buttons
    ),
  );
}
