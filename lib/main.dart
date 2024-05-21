import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:racingr/pages/welcome.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      //   apiKey: "AIzaSyBLO0prFB3d7CWh6TUURF6JcVOSGu7q8vo",
      //   appId: "1:816755246635:android:0953400d1befdc1c160c6e",
      //   messagingSenderId: "XXX",
      //   projectId: "racing-gr",
      // ),
      );
//above commented code use for running flutter app on chrome
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: welcomepage(),
    );
  }
}
