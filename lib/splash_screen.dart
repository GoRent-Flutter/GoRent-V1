import 'package:flutter/cupertino.dart';
import 'package:gorent_application1/constraints.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryRed,
      child: Center(
        child: Hero(
          tag: 'logo',
          child: Image.asset('assets/images/GoRent.png'),
        ),
      ),
    );
  }
}
