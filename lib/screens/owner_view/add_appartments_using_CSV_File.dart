import 'package:flutter/material.dart';

class UploadAppartmentsUsingCsvScreen extends StatelessWidget {
  const UploadAppartmentsUsingCsvScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحميل من ملف CSV'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement your CSV upload logic here
          },
          child: const Text('تحميل الملف'),
        ),
      ),
    );
  }
}