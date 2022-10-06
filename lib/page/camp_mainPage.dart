import 'package:camper/color/color.dart';
import 'package:camper/page/location_page.dart';
import 'package:camper/widget/decoration.dart';
import 'package:camper/widget/widget_box.dart';
import 'package:flutter/material.dart';

import '../data/camp_data.dart';
import '../service/http.dart';

class MainCamp extends StatefulWidget {
  const MainCamp({Key? key}) : super(key: key);

  @override
  State<MainCamp> createState() => _MainCampState();
}

class _MainCampState extends State<MainCamp> {
  WidgetBox widgetBox = WidgetBox();
  DecorationWidgetBox decorationWidgetBox = DecorationWidgetBox();
  List<String> categoryIcon = [
    "lib/asset/caravan.png",
    "lib/asset/glamping.png",
    "lib/asset/bonfire.png",
  ];
  List <String> camp = ["카라반","글램핑","오토캠핑"];
  List<CampData> campList = [];
  CampApi campApi = CampApi();

  void getCampData()async{
    campList = (await campApi.getCampList(context: context))!;
    setState(() {});
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCampData();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getCampData,
      ),
        appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "더 캠퍼",
            style: TextStyle(
              color: ColorBox.backColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              color: Colors.white,
              width: 400,
              height: 70,
              margin: EdgeInsets.only(left: 90),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoryIcon.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 5,),
                      GestureDetector(
                        child: Image.asset(
                          categoryIcon[index],
                          width: 40,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(camp[index])
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 50);
                },
              ),
            ),
            Divider(
              thickness: 1.3,
              indent: 10,
              endIndent: 10,
            ),

            Expanded(
              child: ListView.separated(
                  shrinkWrap: false,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: widgetBox.campingListWidget(
                          campList[index].firstImageUrl == null ? "asdasda" : campList[index].firstImageUrl.toString(),
                          campList[index].tel.toString(),
                          "위치",
                          "이름"),
                    );
                  },
                  separatorBuilder: (ctx, idx) {
                    return decorationWidgetBox.listMargin();
                  },
                  itemCount: campList.length),
            ),
          ],
        ),
    );
  }
}
