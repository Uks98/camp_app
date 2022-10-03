import 'package:flutter/material.dart';

class MainCamp extends StatefulWidget {
  const MainCamp({Key? key}) : super(key: key);

  @override
  State<MainCamp> createState() => _MainCampState();
}

class _MainCampState extends State<MainCamp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("hello! page"),
    );
  }
}
