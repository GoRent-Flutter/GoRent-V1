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
        body: 
        Container(
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
                    fontSize: 17,
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
                    setState(() {
                      selectedOption = value;
                    });
                  },
                  hint: const Text('اختيار مشكلة',
                      textDirection: TextDirection.rtl),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: primaryRed),
                ),
              ),
            ),
            Positioned(
              top: size.width / 2 +15,
              left: size.width / 2 +95,
              right: 16,
              child: Text('وصف المشكلة'),
            ),
           Positioned(
              top: size.width / 2 + 80,
              left: 16,
              right: 16,
              child: Column(
          children: <Widget>[
            TextField(
              
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryHint),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryRed),
                ),
              ),
              textDirection: TextDirection.rtl,
              maxLines: null,
            ),
          ],
              ),
            ),
          ]),
        ));
  }
}
