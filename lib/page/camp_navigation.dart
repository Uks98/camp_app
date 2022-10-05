import 'package:camper/color/color.dart';
import 'package:camper/page/camp_mainPage.dart';
import 'package:camper/page/location_page.dart';
import 'package:camper/widget/decoration.dart';
import 'package:camper/widget/widget_box.dart';
import 'package:flutter/material.dart';

class CampNavigation extends StatefulWidget {
  const CampNavigation({Key? key}) : super(key: key);

  @override
  State<CampNavigation> createState() => _CampNavigationState();
}

class _CampNavigationState extends State<CampNavigation> {
  int _selectIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    MainCamp(),
    LocationPage(),
  ];
  WidgetBox widgetBox = WidgetBox();
  DecorationWidgetBox decorationWidgetBox = DecorationWidgetBox();
  List<String> categoryIcon = [
    "lib/asset/caravan.png",
    "lib/asset/glamping.png",
    "lib/asset/bonfire.png",
    "lib/asset/caravan.png"
  ];
  void _onItemTapped(int index) { // 탭을 클릭했을떄 지정한 페이지로 이동
    setState(() {
      _selectIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.text_snippet),
              label: '나의 판매글',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '마이페이지',
            ),
          ],
          currentIndex: _selectIndex, // 지정 인덱스로 이동
          selectedItemColor: Colors.lightGreen,
          onTap: _onItemTapped, // 선언했던 onItemTapped
        ),
        body: SafeArea(child: _widgetOptions.elementAt(_selectIndex)));
  }
}
