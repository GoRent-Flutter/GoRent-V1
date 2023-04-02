import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';

import '../../user_bottom_nav_bar.dart';
import '../BuyList/buylist_screen.dart';
import '../RentList/rentlist_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isPopular = true;
  bool isNewlyAdded = false;
  bool isRecommended = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryGrey,
      child: SizedBox(
          child: Stack(children: <Widget>[
        const Positioned(
            child: Scaffold(
          bottomNavigationBar: BottomNavBar(),
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
          top: 200,
          left: 25,
          right: 207,
          child: Container(
            height: 177,
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
            child: GestureDetector(
            child: Stack(
              children: [
                Positioned(
                  
                  top: 5,
                  left: 5,
                  right: 5,
                  bottom: 30,
                  
                  child: Transform.scale(
                    scale: 1.0,
                    child: Image.asset('assets/icons/buy.png'),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Text(
                          "شراء عقار",
                          style: TextStyle(
                            fontSize: 17,
                            color: primaryRed,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => BuyListScreen(),
                        ));
                      },
),
          ),
        ),
        Positioned(
          top: 200,
          left: 207,
          right: 25,
          child: Container(
            height: 177,
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
           child: GestureDetector(
            child: Stack(
              children: [
                Positioned(
                  
                  top: 5,
                  left: 5,
                  right: 5,
                  bottom: 30,
                  
                  child: Transform.scale(
                    scale: 1.0,
                    child: Image.asset('assets/icons/rent.png'),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Text(
                          "استئجار عقار",
                          style: TextStyle(
                            fontSize: 17,
                            color: primaryRed,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => RentListScreen(),
                        ));
                      },
),
          ),
        ),
        Positioned(
            top: 420,
            left: 35,
            right: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPopular = true;
                      isNewlyAdded = false;
                      isRecommended = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "رائج",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 17,
                            color: isPopular ? primaryLine : primaryRed),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 1,
                        width: 71,
                        color: isPopular ? primaryLine : Colors.transparent,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPopular = false;
                      isNewlyAdded = false;
                      isRecommended = true;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "موصى به",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 17,
                            color: isRecommended ? primaryLine : primaryRed),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 1,
                        width: 71,
                        color: isRecommended ? primaryLine : Colors.transparent,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPopular = false;
                      isNewlyAdded = true;
                      isRecommended = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "مضاف حديثا",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 17,
                            color: isNewlyAdded ? primaryLine : primaryRed),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 1,
                        width: 71,
                        color: isNewlyAdded ? primaryLine : Colors.transparent,
                      )
                    ],
                  ),
                )
              ],
            )),
        Positioned(
          top: 485,
          left: 25,
          right: 25,
          bottom: 80,
          child: Container(
            height: 243,
            width: 350,
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
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 337,
                  decoration: BoxDecoration(
                    color: primaryRed,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("400",
                          style: TextStyle(
                              fontSize: 20, decoration: TextDecoration.none)),
                      Text("اسم العقار",
                          style: TextStyle(
                              fontSize: 20, decoration: TextDecoration.none)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Image(
                        image: AssetImage('assets/icons/Red_bedroom.png'),
                        width: 23,
                        height: 18,
                      ),
                      SizedBox(width: 8),
                      Text("2",
                          style: TextStyle(
                              fontSize: 18, decoration: TextDecoration.none)),
                      SizedBox(width: 15),
                      Image(
                        image: AssetImage('assets/icons/Red_bathroom.png'),
                        width: 23,
                        height: 18,
                      ),
                      SizedBox(width: 8),
                      Text("2",
                          style: TextStyle(
                              fontSize: 18, decoration: TextDecoration.none)),
                      SizedBox(width: 15),
                      Image(
                        image: AssetImage('assets/icons/Red_size.png'),
                        width: 23,
                        height: 18,
                      ),
                      SizedBox(width: 8),
                      Text("200",
                          style: TextStyle(
                              fontSize: 18, decoration: TextDecoration.none)),
                       SizedBox(width: 40),
                    Text("منزل للإيجار",
                          style: TextStyle(
                              fontSize: 18, decoration: TextDecoration.none))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ])),
    );
  }
}
