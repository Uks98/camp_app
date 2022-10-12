import 'package:camper/color/color.dart';
import 'package:camper/data/search_camp.dart';
import 'package:camper/page/detail_page.dart';
import 'package:camper/page/location_page.dart';
import 'package:camper/page/search_keyword_page.dart';
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
  String _keyword = "";
  WidgetBox _widgetBox = WidgetBox();
  DecorationWidgetBox _decorationWidgetBox = DecorationWidgetBox();
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

  void getCategory(int index){
    if(index == 0){
      _keyword = "카라반";
    }else if(index == 1){
      _keyword = "글램핑";
    }else{
      _keyword = "오토캠핑";
    }
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
        body: ListView.separated(
            shrinkWrap: false,
            itemBuilder: (context, index) {
              if(index == 0){
                return Container(
                  margin: EdgeInsets.only(top: 25,left: 20,bottom: 8),
                  child: Text("The Camp",style: TextStyle(fontSize: 25,),));
              }else if(index == 1){
                return Container(
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
                            onTap: (){
                              getCategory(index);
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>KeyWordPage(keyword: _keyword)));
                            },
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
                );
              }return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                      DetailPage(
                        campData: CampData(
                            campName: campList[index].campName,
                            campId: campList[index].campId,
                            insrncAt : campList[index].insrncAt,
                            feather : campList[index].feather,
                            address : campList[index].address,
                            mapx : campList[index].mapx,
                            mapy : campList[index].mapy,
                            tel : campList[index].tel,
                            homePage : campList[index].homePage,
                            resveUrl : campList[index].resveUrl,
                            nomalSite : campList[index].nomalSite,
                            autoSiteCo : campList[index].autoSiteCo,
                            glamping : campList[index].glamping,
                            caravSite : campList[index].caravSite,
                            glamInside : campList[index].glamInside,
                            caravanInside : campList[index].caravanInside,
                            operPd : campList[index].operPd,
                            operDay : campList[index].operDay,
                            intro : campList[index].intro,
                            mainIntro : campList[index].mainIntro,
                            firstImageUrl : campList[index].firstImageUrl,
                            toilet : campList[index].toilet,
                            shower : campList[index].shower,
                            wtrplCo : campList[index].wtrplCo,
                            freeCon : campList[index].freeCon,
                            freeCon2 : campList[index].freeCon2,
                            posblFcltyCl : campList[index].posblFcltyCl,
                            ProgrmBool : campList[index].ProgrmBool,
                            ProgrmName : campList[index].ProgrmName,
                            extshrCo : campList[index].extshrCo,
                            fireSensorCo : campList[index].fireSensorCo,
                            thema : campList[index].thema,
                        ),
                      )
                  ));
                },
                child: _widgetBox.campingListWidget(
                    campList[index].firstImageUrl == null ? "asdasda" : campList[index].firstImageUrl.toString(),
                    campList[index].campName.toString(),
                    campList[index].address.toString(),
                  campList[index].intro.toString(),),
              );
            },
            separatorBuilder: (ctx, idx) {
              return _decorationWidgetBox.listMargin();
            },
            itemCount: campList.length),
    );
  }
}
