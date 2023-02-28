import 'package:flutter/material.dart';
import '../../constraints.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        child: SizedBox(
            width: 100,
            height: 100,
            child: Stack(children: <Widget>[
              Positioned(
                // top: -10,
                  left: 0,
                  right: 0,
                  child: Transform.scale(
                    scale: 1.08,
                    child: Image.asset('assets/icons/GoRent_Logo_Inside.png'),
                  )
              ),
            ]
            )
        )

    );
  }
}