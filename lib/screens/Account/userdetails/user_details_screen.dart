import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Account/user_account_screen.dart';

import '../../users/users_screen.dart';
import 'change_password_screen.dart';

class EditProfilePageState extends StatelessWidget {
  const EditProfilePageState({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 1,
        leading: IconButton(
          icon: Image.asset('assets/icons/Red_back.png', width: 24, height: 24),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserAccountScreen()),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersScreen()),
                );
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: primaryRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Container(
                alignment: AlignmentDirectional.centerEnd,
                child: const Text(
                  "آنت",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    color: primaryRed,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              buildTextField("اسمك", "ايمان خلف"),
              buildTextField(
                  "البريد الآليكتروني", "eman.mufeed.khala@gmail.com"),
              buildTextField("رقم التواصل", "٠٥٩٩٨٣٤٥٤٦٤"),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const ChangePasswordScreen()),
                      );
                    },
                    child: Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          Row(
                            children: const [
                              Icon(Icons.arrow_back_ios,
                                  size: 22, color: Colors.black),
                              SizedBox(width: 10),
                              Text(
                                "تغيير كلمة المرور",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(37.0),
                    ),
                  ),
                  child: const Text(
                    'حفظ',
                    style: TextStyle(
                      color: primaryWhite,
                      fontSize: 21.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            alignLabelWithHint: true,
          ),
        ),
      ),
    );
  }
}
