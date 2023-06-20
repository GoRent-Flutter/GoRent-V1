import 'package:firebase_messaging/firebase_messaging.dart';

class pushNotificationManager {
  pushNotificationManager._();

  factory pushNotificationManager() => _instance;  

  static final pushNotificationManager _instance =pushNotificationManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _initialized = false;
  Future<void> init() async{
    if(!_initialized){
      //iOS
      // _firebaseMessaging.requestPermission();
     // _firebaseMessaging._configure();
      String? token = await _firebaseMessaging.getToken();
      print("Token= $token");
      _initialized=true;
    }
  }
}