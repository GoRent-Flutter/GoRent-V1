import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../Models_Folder/CustModel.dart';
import '../owner_view/owner_view_screen.dart';

class AboutYouScreen extends StatelessWidget {
  final String userId;
  final int currentIndex;
  AboutYouScreen({Key? key, required this.userId, required this.currentIndex})
      : super(key: key);

  TextEditingController fullnameController = TextEditingController();
  TextEditingController phone_numberController = TextEditingController();

  Future<bool> userValues() async {
    String fullname = fullnameController.text;
    String phone_number = phone_numberController.text;
    if (fullname == "" || phone_number == "") {
      //a text should appear to the user/owner (will do this later)
      print("fill the empty fields!");
      return false;
    } else {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
       try {
        if (currentIndex == 1) {
          await firestore.collection('customers').doc(userId).update({
            'fullname': fullname,
            'phone_number': phone_number,
            'city': "",
          });

          // Generate and store session ID
            String sessionId = Uuid().v4();

            //distinguish between customer and owner session ID
            String userSessionId = sessionId + ".customer";
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('sessionId', userSessionId);
          return true;
        } else if (currentIndex == 0) {
          await firestore.collection('owners').doc(userId).update({
            'fullname': fullname,
            'phone_number': phone_number,
            'city': "",
          });
          
          // Generate and store session ID
            String sessionId = Uuid().v4();

            //distinguish between customer and owner session ID
            String userSessionId = sessionId + ".owner";
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('sessionId', userSessionId);
          return true;
        }
      } catch (ex) {
        print(ex.toString());
        return false;
      }
    }
    return false;
       
    }

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
                    child: TextField(
                      controller: fullnameController,
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
                    child: TextField(
                      controller: phone_numberController,
                      keyboardType: TextInputType.number,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: selectedOption,
                            items: cities.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: primaryHint,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {},
                            hint: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'المدينة',
                              ),
                            ),
                            isExpanded: true,
                            underline: const SizedBox.shrink(),
                          ),
                        ),
                      ],
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
                onPressed: () async {
                  bool success = await userValues();
                  if (success == true) {
                    currentIndex == 1
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen()))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OwnerScreen()),
                          );
                  } else if (success == false) {
                    print("an error occurred while trying to sign up");
                  }
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(width: 1, color: primaryWhite),
                  backgroundColor: primaryRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(37.0),
                  ),
                ),
                child: const Text('هيا نبدأ!',
                    style: TextStyle(
                      color: primaryWhite,
                      fontSize: 21.0,
                    ),
                    textDirection: TextDirection.rtl),
              )),
        ]));
  }
}
