import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:gorent_application1/user_bottom_nav_bar.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        // child: SizedBox(
        //     width: 100,
        //     height: 100,
        child: Stack(children: <Widget>[
          const Positioned(
              child: Scaffold(
            bottomNavigationBar: BottomNavBar(currentIndex: 1),
          )),
          Positioned(
              // top: -10,
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset('assets/icons/GoRent_Logo_Inside.png'),
              )),
          Positioned(
            top: -40,
            left: -50,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              child: Transform.scale(
                scale: 0.2,
                child: Image.asset('assets/icons/White_back.png'),
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 25,
            right: 25,
            child: Container(
              height: size.height * 0.75,
              decoration: BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: size.width / 2 - 60,
            child: const Text(
              "العقارات المفضلة",
              style: TextStyle(
                 fontFamily:'Scheherazade_New',
                fontSize: 20,
                color: primaryRed,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ]));
  }
}
