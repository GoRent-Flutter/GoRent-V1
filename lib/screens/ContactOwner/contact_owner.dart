import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:url_launcher/url_launcher.dart';
class ContactOwnerScreen extends StatefulWidget {
  const ContactOwnerScreen({Key? key}) : super(key: key);

  @override
  ContactOwnerState createState() => ContactOwnerState();
}

class ContactOwnerState extends State<ContactOwnerScreen> {
  bool propertiesInfo = true;
  bool aboutOwner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        color: primaryGrey,
        child: SizedBox(
            child: Stack(children: <Widget>[
          Positioned(
              // top: -10,
              left: 0,
              right: 0,
              child: Transform.scale(
                scale: 1.0,
                child: Image.asset('assets/images/GoRent_cover.png'),
              )),
          Positioned(
            top: -40,
            left: -50,
            child: GestureDetector(
              onTap: () {
                /////////fix here
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const MainScreen()),
                // );
              },
              child: Transform.scale(
                scale: 0.2,
                child: Image.asset('assets/icons/White_back.png'),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: size.width - 150,
            right: 5,
            child: const CircleAvatar(
              radius: 50,
              // backgroundImage: AssetImage('assets/icons//White_back.png'),
            ),
          ),
          Positioned(
            top: 250,
            left: size.width - 130,
            
            child: const Text(
              "اسم المالك",
              style: TextStyle(
                  fontSize: 23,
                  color: primaryRed,
                  decoration: TextDecoration.none),
            ),
          ),
          Positioned(
            top: 290,
            left: size.width - 170,
            
            child: Text(
              "صاحب عقار في رام الله",
              style: TextStyle(
                  fontSize: 15,
                  color: primaryHint.withOpacity(0.6),
                  decoration: TextDecoration.none),
            ),
          ),
       Positioned(
  top: 330,
  left: 5,
  right: 5,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TextButton(
              onPressed: () {
              //direct trans
                launch('tel:+970599999999');
              },
              style: TextButton.styleFrom(
                backgroundColor: primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23.0),
                ),
                minimumSize: const Size(165, 45),
              ),
              child: const Text(
                'الإتصال',
                style: TextStyle(
                  color: primaryWhite,
                  fontSize: 20.0,
                ),
              ),
            ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: TextButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const MainScreen()),
                // );
              },
              style: TextButton.styleFrom(
                backgroundColor: primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23.0),
                ),
                minimumSize: const Size(165, 45),
              ),
              child: const Text(
                'المراسلة',
                style: TextStyle(
                  color: primaryWhite,
                  fontSize: 20.0,
                ),
              ),
            ),
      ),
    ],
  ),
),
  Positioned(
            top: size.height - 380,
            left: 35,
            right: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      propertiesInfo = true;
                      aboutOwner = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "العقارات",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 21,
                            color: propertiesInfo ? primaryLine : primaryRed),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 1,
                        width: 100,
                        color: propertiesInfo ? primaryLine : Colors.transparent,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      propertiesInfo = false;
                      aboutOwner = true;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "عن المالك",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 21,
                            color: aboutOwner ? primaryLine : primaryRed),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 1,
                        width: 100,
                        color: aboutOwner ? primaryLine : Colors.transparent,
                      )
                    ],
                  ),
                ),
              ],
            )),
           aboutOwner ?  Stack(children: <Widget>[
            Positioned(
        top: size.height - 320,
        left: size.width - 140,
        child:  const Text("البريد الإلكتروني",
        style: TextStyle(
          fontSize: 18,
          color: primaryRed,
          decoration: TextDecoration.none,
        ),
      ),),
     
      //  SizedBox(height: 10),
Positioned(
        top: size.height - 280,
        left: size.width - 190,
        child:  Text("owner@gorent.ps",
        style: TextStyle(
          fontSize: 18,
          color: primaryRed,
          decoration: TextDecoration.none,
        ),
      ),),
      Positioned(
        top: size.height - 230,
        left: size.width - 110,
        child:  const Text("رقم الهاتف",
        style: TextStyle(
          fontSize: 18,
          color: primaryRed,
          decoration: TextDecoration.none,
        ),
      ),),
      Positioned(
        top: size.height - 190,
        left: size.width - 170,
        child:  Text("+970599999999",
        style: TextStyle(
          fontSize: 18,
          color: primaryRed,
          decoration: TextDecoration.none,
        ),
      ),),
            ]) 
            : Positioned(
  top: size.height - 330,
  left: 30,
  right: 30,
  child: const Text("not available yet",
    style: TextStyle(
      fontSize: 12,
      color: primaryRed,
      decoration: TextDecoration.none,
    ),
  ),
),



        ])));
  }
}