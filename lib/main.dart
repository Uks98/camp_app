import 'package:camper/page/login_signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context,child) => MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor:1.0 ), child: child!),
      title: 'The Camper',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "dream"
      ),
      home: LoginSignupScreen(),
    );
  }
}

