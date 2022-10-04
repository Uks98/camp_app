import 'package:flutter/material.dart';

class MainCamp extends StatefulWidget {
  const MainCamp({Key? key}) : super(key: key);

  @override
  State<MainCamp> createState() => _MainCampState();
}

class _MainCampState extends State<MainCamp> {
  @override
  Widget build(BuildContext context) {
    String name = "캠핑,미국,영국,중국";
    return Scaffold(
      body: Text("hello! page"),
    );
  }
}
