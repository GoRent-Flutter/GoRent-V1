import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:gorent_application1/constraints.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  bool isSuccess = false;
  bool isPasswordMismatch = false;

  Future<void> resetPassword(BuildContext context) async {
    String email = emailController.text.trim();
    String newPassword = newPasswordController.text;
    String confirmNewPassword = confirmNewPasswordController.text;

    if (email.isEmpty ||
        newPassword.isEmpty ||
        confirmNewPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى ملء جميع الحقول'), // Please fill in all fields
        ),
      );
      return;
    }

    if (newPassword != confirmNewPassword) {
      setState(() {
        isPasswordMismatch = true;
      });
      return;
    }

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Check if the user exists in the "customers" collection
      final customersQuery = await firestore
          .collection('customers')
          .where('email', isEqualTo: email)
          .get();

      // Check if the user exists in the "owners" collection
      final ownersQuery = await firestore
          .collection('owners')
          .where('email', isEqualTo: email)
          .get();

      if (customersQuery.docs.isNotEmpty || ownersQuery.docs.isNotEmpty) {
        String userId = '';

        if (customersQuery.docs.isNotEmpty) {
          userId = customersQuery.docs.first.id;
        } else if (ownersQuery.docs.isNotEmpty) {
          userId = ownersQuery.docs.first.id;
        }

        String hashedNewPassword =
            BCrypt.hashpw(newPasswordController.text, BCrypt.gensalt());

        // Update the password in the respective collection
        if (customersQuery.docs.isNotEmpty) {
          await firestore
              .collection('customers')
              .doc(userId)
              .update({'password': hashedNewPassword});
        } else if (ownersQuery.docs.isNotEmpty) {
          await firestore
              .collection('owners')
              .doc(userId)
              .update({'password': hashedNewPassword});
        }

        setState(() {
          isSuccess = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء تغيير كلمة المرور'), // An error occurred while changing the password
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تغيير كلمة المرور'), // An error occurred while changing the password
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Set the background color to white
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isSuccess
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 48.0,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'تم تغيير كلمة المرور بنجاح',
                      style: TextStyle(fontSize: 18.0), // Password changed successfully
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'إغلاق',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryRed, // Set the button color to red
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'البريد الإلكتروني'), // Email
                    ),
                    TextField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                          labelText: 'كلمة المرور الجديدة'), // New Password
                      obscureText: true,
                    ),
                    TextField(
                      controller: confirmNewPasswordController,
                      decoration: InputDecoration(
                          labelText: 'تأكيد كلمة المرور الجديدة'), // Confirm New Password
                      obscureText: true,
                    ),
                    SizedBox(height: 16.0),
                    if (isPasswordMismatch)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'كلمة المرور الجديدة لا تتطابق مع التأكيد',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isPasswordMismatch = false;
                        });
                        resetPassword(context);
                      },
                      child: Text(
                        'تغيير كلمة المرور',
                        style: TextStyle(color: Colors.white), // Change Password
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryRed, // Set the button color to red
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
