import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:gorent_application1/screens/Map/map_screen.dart';
import 'package:gorent_application1/screens/Welcome/welcome_screen_customer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/application_bloc.dart';

class GuestBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const GuestBottomNavBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  GuestBottomNavBarState createState() => GuestBottomNavBarState();
}

class GuestBottomNavBarState extends State<GuestBottomNavBar> {
  late int currentIndex;
  // bool isGuest = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryGrey,
      bottomNavigationBar: Container(
        height: displayWidth * .155,
        decoration: BoxDecoration(
          color: primaryWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
            ),
          ],
          borderRadius: const BorderRadius.only(
              // topLeft: Radius.circular(24),
              // topRight: Radius.circular(24),
              ),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: displayWidth * .055),
          //index is for listview
          //currentIndex is for navBar >> keeps track of the currently selected index of the bottom nav bar.
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {
                currentIndex = index;
                print(currentIndex);
                // if (isGuest) {
                if (currentIndex == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen(
                              currentIndex: 2,
                            )),
                  );
                } else if (currentIndex == 1) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('انشاء حساب'),
                        content: const Text(
                            'انت تحتاج ان تقوم بآنشاء حساب لتصفح هذه الميزة'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              // Navigate to the WelcomeScreenCustomer
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreenCustomer()),
                              );

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('sessionId');
                            },
                            child: const Text(
                              'انشاء حساب',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryRed),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else if (currentIndex == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => ApplicationBloc(),
                        child: const MapScreen(
                          currentIndex: 2,
                        ),
                      ),
                    ),
                  );
                } else if (currentIndex == 3) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('انشاء حساب'),
                        content: const Text(
                            'انت تحتاج ان تقوم بآنشاء حساب لتصفح هذه الميزة'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              // Navigate to the WelcomeScreenCustomer
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreenCustomer()),
                              );

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('sessionId');
                            },
                            child: const Text(
                              'انشاء حساب',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryRed),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                // } else {
                //   if (currentIndex == 0) {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const MainScreen(
                //                 currentIndex: 1,
                //               )),
                //     );
                //   } else if (currentIndex == 1) {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const FavouriteScreen()),
                //     );
                //   } else if (currentIndex == 2) {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => ChangeNotifierProvider(
                //           create: (context) => ApplicationBloc(),
                //           child: const MapScreen(
                //             currentIndex: 1,
                //           ),
                //         ),
                //       ),
                //     );
                //   } else if (currentIndex == 3) {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const UserAccountScreen()),
                //     );
                //   }
                // }
              });
            },
            child: Stack(
              children: [
                //circle
                AnimatedContainer(
                  //duration to move the animated container
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == currentIndex
                      ? displayWidth * .32
                      : displayWidth * .18,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: index == currentIndex ? displayWidth * .12 : 0,
                    width: index == currentIndex ? displayWidth * .32 : 0,
                    decoration: BoxDecoration(
                      color: index == currentIndex
                          ? primaryNav
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                //icons color and text
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          //for text
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == currentIndex ? displayWidth * .13 : 0,
                          ),
                          AnimatedOpacity(
                            opacity: index == currentIndex ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Text(
                              index == currentIndex ? listOfChoices[index] : '',
                              style: const TextStyle(
                                color: primaryWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //changing icons color
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == currentIndex ? displayWidth * .03 : 20,
                          ),
                          Icon(
                            listOfIcons[index],
                            size: displayWidth * .076,
                            color: index == currentIndex
                                ? primaryWhite
                                : primaryNav,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_outlined,
    Icons.favorite_outline_outlined,
    Icons.map_outlined,
    Icons.person_outline,
  ];

  List<String> listOfChoices = [
    'الرئيسية',
    'المفضلة',
    'الخريطة',
    'الحساب',
  ];
}
