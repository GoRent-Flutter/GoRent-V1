import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  AppSettings.openNotificationSettings();
                },
                child: const Text('Enable'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
