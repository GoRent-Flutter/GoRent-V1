import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/BuyList/buylist_screen.dart';

import '../ItemDetail/itemdetailbuy_screen.dart';
import '../ItemDetail/itemdetailrent_screen.dart';

class MyCard extends StatelessWidget {
  final Widget child;

  final Estate estate;

  const MyCard({Key? key, required this.estate, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailBuy(estate: estate),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
        child: Container(
          height: size.width*0.58,
          // color: Colors.deepPurple[200],
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
               color:Colors.black.withOpacity(0.3),
               spreadRadius: 2,
                blurRadius: 5,
                // offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // SizedBox(height: 10),
              // Image.asset(
              //   '',
              //   height: 120,
              //   width: 120,
              // ),
              // SizedBox(height: 0),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
