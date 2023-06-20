import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user_account_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final int currentIndex;
  const ChangePasswordScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPassword = false;

  Future<void> changePassword(BuildContext context) async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى ملء جميع الحقول'),
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('كلمة المرور الجديدة غير متطابقة مع التأكيد'),
        ),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('sessionId');
      List<String> parts = sessionId!.split('.');
      String mergedID = parts[1] + '.' + parts[2];

      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userDoc;
      if (parts[2].contains("GRCU")) {
        userDoc = await firestore.collection('customers').doc(mergedID).get();
      } else {
        userDoc = await firestore.collection('owners').doc(mergedID).get();
      }

      String hashedOldPassword = userDoc.data()!['password'];
      bool isPasswordMatched = BCrypt.checkpw(oldPassword, hashedOldPassword);

      if (isPasswordMatched) {
        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

        // Update the password in the collection
        await userDoc.reference.update({'password': hashedNewPassword});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تغيير كلمة المرور بنجاح'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('كلمة المرور القديمة غير صحيحة'),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تغيير كلمة المرور'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: primaryRed,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserAccountScreen(currentIndex: widget.currentIndex),
                      ),
                    );
                  },
                ),
                const Text(
                  'تغيير كلمة المرور',
                  style: TextStyle(
                    fontSize: 22,
                    color: primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48), // add some space for better alignment
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    TextField(
                      controller: _oldPasswordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الحالية',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => changePassword(context),
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
          ],
        ),
      ),
    );
  }
}