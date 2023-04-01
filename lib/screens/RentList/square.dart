import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/RentList/rentlist_screen.dart';
import 'package:gorent_application1/screens/BuyList/buylist_screen.dart'
    as buylist;

import '../ItemDetail/itemdetailrent_screen.dart';

class MySquare extends StatelessWidget {
  final Widget child;

  final Post post;

  const MySquare({Key? key, required this.post, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetail(post: post),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 1),
        child: Container(
          height: 230,
          // color: Colors.deepPurple[200],
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                // spreadRadius: 2,
                blurRadius: 5,
                // offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Image.asset(
              //   '',
              //   height: 120,
              //   width: 120,
              // ),
              SizedBox(height: 0),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
