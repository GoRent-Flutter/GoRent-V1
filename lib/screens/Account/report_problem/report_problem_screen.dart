import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import '../user_account_screen.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({Key? key}) : super(key: key);

  @override
  ReportProblemState createState() => ReportProblemState();
}

class ReportProblemState extends State<ReportProblemScreen> {
  @override
  Widget build(BuildContext context) {
    String? selectedOption;
    final List<String> options = [
      'مشكلة في معلومات الحساب',
      'مشكلة في الرسائل',
      'مشكلة في العقارات المعروضة',
      'أخرى',
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: primaryWhite,
        appBar: AppBar(
          backgroundColor: primaryWhite,
          elevation: 1,
          leading: IconButton(
            icon:
                Image.asset('assets/icons/Red_back.png', width: 24, height: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserAccountScreen()),
              );
            },
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16, top: 16),
              child: Text(
                'الإبلاغ عن مشكلة',
                style: TextStyle(
                  color: primaryRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(children: <Widget>[
            Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: Container(
                alignment: AlignmentDirectional.centerEnd,
                child: const Text(
                  "إذا كنت تواجه مشكلة في GoRent، فقد وصلت إلى المكان الصحيح. يرجى استخدام هذا النموذج لإخبارنا عن المشكلة التي تواجهها.",
                  style: TextStyle(
                    fontFamily: 'Scheherazade_New',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryHint,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            Positioned(
              child: Padding(
                padding: EdgeInsets.only(
                    top: size.width / 2 - 60,
                    left: size.width / 2 - 20,
                    right: 16),
                child: DropdownButton<String>(
                  value: selectedOption,
                  items: options.map((String option) {
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
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                  hint: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'اختر مشكلة',
                      style: TextStyle(
                          fontFamily: 'Scheherazade_New', fontSize: 16),
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: primaryRed),
                ),
              ),
            ),
            Positioned(
              top: size.width / 2 + 15,
              left: size.width /2 + 82,
              right: 16,
              child: Text(
                'وصف المشكلة',
                style: TextStyle(
                  fontFamily: 'Scheherazade_New',
                  fontSize: 16
                ),
              ),
            ),
            Positioned(
              top: size.width / 2 + 50,
              left: 16,
              right: 16,
              child: Column(
                children: <Widget>[
                  LimitedBox(
                    maxHeight:
                        size.width / 4, // set the maximum height of the box
                    child: Container(
                      height: size.width / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: primaryHint.withOpacity(0.2),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryWhite,
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          textDirection: TextDirection.rtl,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.width / 2 + 170,
              left: size.width / 3,
              child: Text('attach a photo/video (later)'),
            ),
            Positioned(
                top: size.height / 2,
                left: 50,
                right: 50,
                child: TextButton(
                  onPressed: () async {
                    //   bool success = await checkValues();
                    //   if (success == true) {
                    //     currentIndex == 1
                    //         ? Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => MainScreen()))
                    //         : Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => OwnerScreen()),
                    //           );
                    //   } else if (success == false) {
                    //     print("an error occurred while trying to sign up");
                    //   }
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(width: 1, color: primaryWhite),
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(37.0),
                    ),
                  ),
                  child: const Text(
                    'إرسال',
                    style: TextStyle(
                      color: primaryWhite,
                      fontSize: 21.0,
                    ),
                  ),
                ))
          ]),
        ));
  }
}
