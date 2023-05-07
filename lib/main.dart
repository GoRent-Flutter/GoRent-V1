import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gorent_application1/constraints.dart';
import 'package:gorent_application1/screens/Main/main_screen.dart';
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
  final String substring0 = 'owner';

  //iff there's a session id, show the logged in screen
  if (sessionId != null) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    //owner screen
    if (sessionId.contains(substring0)) {
      runApp(const MyAppLoggedIn(currentIndex: 0));
      return;
    }
    
    //customer screen
    runApp(const MyAppLoggedIn(currentIndex: 1));
      return;
  }

  //if there is no session id, show not logged in screen
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return UsersScreen();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}

//Logged in user
class MyAppLoggedIn extends StatelessWidget {
  final int currentIndex;
  const MyAppLoggedIn({Key? key, required this.currentIndex}) : super(key: key);
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
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              currentIndex == 1) {
            //customer login
            return MainScreen();
          } else if (snapshot.connectionState == ConnectionState.done &&
              currentIndex == 0) {
            //owner login
            return OwnerScreen();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
