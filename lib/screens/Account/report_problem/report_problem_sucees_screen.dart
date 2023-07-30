import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constraints.dart';
import '../../owner_view/owner_view_screen.dart';
import '../user_account_screen.dart';

class SuccessScreenReportProblemState extends StatefulWidget {
  final int currentIndex;

  const SuccessScreenReportProblemState({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  _SuccessScreenReportProblemState createState() =>
      _SuccessScreenReportProblemState();
}

class _SuccessScreenReportProblemState
    extends State<SuccessScreenReportProblemState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'لقد تم قبول مشكلتك سنحاول حلها في أسرع وقت ممكن',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserAccountScreen(currentIndex: widget.currentIndex)),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'حسنًا',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
