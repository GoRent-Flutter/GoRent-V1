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
    Size size = MediaQuery.of(context).size;
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
        child: Container(
          height: size.width * 0.58,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              child,
            ],
          ),
        ),
      ),
    );
  }
}
