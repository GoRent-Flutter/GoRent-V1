import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:gorent_application1/screens/SignUp/signup_screen.dart';
import 'package:gorent_application1/user_bottom_nav_bar.dart';

class AboutYouScreen extends StatelessWidget {
  const AboutYouScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedOption;
    final List<String> cities = [
      'رام الله',
      'بيت لحم',
      'جنين',
      'الخليل',
      'نابلس',
      'طولكرم',
    ];
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        // child: SizedBox(
        //     width: 100,
        //     height: 100,
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
            left: size.width / 2 - 40,
            child: const Text(
              "عن نفسك",
              style: TextStyle(
                fontSize: 20,
                color: primaryRed,
                decoration: TextDecoration.none,
              ),
            ),
          ),
           Positioned(
                top: 240,
                left: 50,
                right: 50,
                child: Column(
                  children: [
                    Material(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryWhite,
                          borderRadius: BorderRadius.circular(13.0),
                          border: Border.all(
                            color: primaryGrey,
                            width: 1,
                          ),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: ' اسم المستخدم',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: primaryHint,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryWhite,
                          borderRadius: BorderRadius.circular(13.0),
                          border: Border.all(
                            color: primaryGrey,
                            width: 1,
                          ),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'رقم الهاتف',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: primaryHint,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                          textAlign: TextAlign.right,
                          obscureText: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryWhite,
                          borderRadius: BorderRadius.circular(13.0),
                          border: Border.all(
                            color: primaryGrey,
                            width: 1,
                          ),
                        ),
                        child: DropdownButton<String>(
                  value: selectedOption,
                  items: cities.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: primaryHint,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    // setState(() {
                    //   selectedOption = value;
                    // });
                  },
                  hint: const Text('المدينة',
                      textDirection: TextDirection.rtl),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: primaryRed),
                ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 480,
                  left: 60,
                  right: 60,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      side: const BorderSide(width: 1, color: primaryWhite),
                      backgroundColor: primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(37.0),
                      ),
                    ),
                    child: const Text(
                      'هيا نبدأ!',
                      style: TextStyle(
                        color: primaryWhite,
                        fontSize: 21.0,
                      ),textDirection: TextDirection.rtl
                    ),
                  )),
        ]));
  }
}
