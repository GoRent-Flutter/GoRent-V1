import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/pushNotificationManager.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
import 'package:gorent_application1/screens/Models_Folder/CustModel.dart';
import 'package:gorent_application1/screens/Models_Folder/FirebaseHelperCustomer.dart';
import 'package:gorent_application1/screens/Models_Folder/FirebaseHelperOwner.dart';
import 'package:gorent_application1/screens/Models_Folder/OwnerModel.dart';
import 'package:gorent_application1/screens/owner_view/owner_view_screen.dart';
import 'package:gorent_application1/splash_screen.dart';
import 'package:gorent_application1/screens/users/users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //check if there's a session id stored in shared prefs
  final prefs = await SharedPreferences.getInstance();
  final sessionId = prefs.getString('sessionId');
  const String substring0 = '-GROW';
  const String substring1 = '-GRCU';

  //iff there's a session id, show the logged in screen
  if (sessionId != null) {
    FirebaseHelperOwner firebaseHelperOwner = FirebaseHelperOwner();
    FirebaseHelperCustomer firebaseHelperCustomer = FirebaseHelperCustomer();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    List<String> parts = sessionId.split('.');
    //owner screen
    if (sessionId.contains(substring0)) {
      OwnerModel? thisOwnerModel =
          await firebaseHelperOwner.getModelById(parts[1]);
      if (thisOwnerModel != null) {
        runApp(LoggedInOwner(ownerModel: thisOwnerModel));
      }
      return;
    }
/********************************************************************************************** */
    // customer screen
    else if (sessionId.contains(substring1)) {
      CustModel? thisCustModel =
          await firebaseHelperCustomer.getModelById(parts[1]);
      if (thisCustModel != null) {
        runApp(LoggedInCustomer(custModel: thisCustModel));
      }
      return;
    }
    else{
      runApp(const MyApp());
    }
  }

  //if there is no session id, show not logged in screen
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  pushNotificationManager manager = pushNotificationManager();
  manager.init();
  runApp(const MyApp());
}

//user not logged in
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoRent',
      theme: ThemeData(
          primaryColor: primaryRed,
          scaffoldBackgroundColor: primaryRed,
          fontFamily: 'Scheherazade_New'),
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const UsersScreen();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}

//owner login
class LoggedInOwner extends StatelessWidget {
  final OwnerModel ownerModel;
  const LoggedInOwner({Key? key, required this.ownerModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoRent',
      theme: ThemeData(
          primaryColor: primaryRed,
          scaffoldBackgroundColor: primaryRed,
          fontFamily: 'Scheherazade_New'),
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return OwnerScreen();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}

//customer login
class LoggedInCustomer extends StatelessWidget {
  final CustModel custModel;
  const LoggedInCustomer({Key? key, required this.custModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoRent',
      theme: ThemeData(
          primaryColor: primaryRed,
          scaffoldBackgroundColor: primaryRed,
          fontFamily: 'Scheherazade_New'),
      home: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const MainScreen(currentIndex: 1,);
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
