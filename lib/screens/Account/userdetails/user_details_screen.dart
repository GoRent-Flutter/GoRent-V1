import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Account/user_account_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'change_password_screen.dart';

class EditProfilePageState extends StatefulWidget {
  final int currentIndex;

  const EditProfilePageState({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  _EditProfilePageStateState createState() => _EditProfilePageStateState();
}

class _EditProfilePageStateState extends State<EditProfilePageState> {
  String username = '';
  String email = '';
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');
    List<String> parts = sessionId!.split('.');
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userDoc;
    if (parts[1].toString().contains("GRCU")) {
      userDoc = await firestore
          .collection('customers')
          .doc(parts[1].toString())
          .get();
    } else {
      userDoc =
          await firestore.collection('owners').doc(parts[1].toString()).get();
    }

    setState(() {
      username = userDoc.data()!['fullname'];
      email = userDoc.data()!['email'];
      phoneNumber = userDoc.data()!['phone_number'];
    });
  }

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
                  builder: (context) =>
                      UserAccountScreen(currentIndex: widget.currentIndex)),
            );
          },
        ),
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
              buildTextField("اسمك", username),
              buildTextField("البريد الآليكتروني", email),
              buildTextField("رقم التواصل", phoneNumber),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChangePasswordScreen(
                              currentIndex: widget.currentIndex),
                        ),
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
