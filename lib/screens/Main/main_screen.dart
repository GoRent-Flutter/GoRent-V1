import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        child: SizedBox(
            // width: 100,
            // height: 100,
            child: Stack(children: <Widget>[
          Positioned(
              // top: -10,
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 1.08,
                child: Image.asset('assets/icons/GoRent_Logo_Inside.png'),
              )),
          Positioned(
            top: 130,
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
              
            child: Stack(
      children: [
        Positioned(
          top: 5,
          left: 5,
          right: 5,
          bottom: 30,
          child: Container(
            decoration: BoxDecoration(
              color: primaryRed,
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
          Center(
          // heightFactor: 1.0,
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
          ),),
          Positioned(
            top: 130,
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
              
 child: Stack(
      children: [
        Positioned(
          top: 5,
          left: 5,
          right: 5,
          bottom: 30,
          child: Container(
            decoration: BoxDecoration(
              color: primaryRed,
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
        ),
          Center(
          // heightFactor: 1.0,
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        "إستئجار عقار",
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
          ),),
        ])));
  }
}
