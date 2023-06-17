import 'package:camper/color/color.dart';
import 'package:camper/data/search_camp.dart';
import 'package:camper/page/detail_page.dart';
import 'package:camper/page/filter_data_page.dart';
import 'package:camper/page/gpt_talk_page.dart';
import 'package:camper/page/search_keyword_page.dart';
import 'package:camper/widget/decoration.dart';
import 'package:camper/widget/widget_box.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

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
    "lib/asset/tent.png",
    "lib/asset/caravan2.png",
    "lib/asset/bonfire2.png",

  ];
  List <String> camp = ["카라반","글램핑","오토캠핑"];
  List <String> recommendLocation = ["애견캠핑 🐕", "체험캠핑 🌊", "키즈캠핑 🐻","AI 캠핑 플래너🤖"];
  List<CampData> campList = [];
  List<CampData> filterCampList = []; //필터된 캠프리스트
  CampApi campApi = CampApi();
  //RecommendFilter recommendFilter = RecommendFilter();
  late bool _isLoading = true; //로딩관련

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
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
   // recommendFilter.getPet();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading ? Skeleton(
          isLoading: _isLoading,
          //https://pub.dev/packages/skeletons
          skeleton: SkeletonListView(
            padding: EdgeInsets.all(20),
          ),
          child: Container(child: Center(child: Text("Content"))),
        ): ListView.separated(
            shrinkWrap: false,
            itemBuilder: (context, index) {
              if(index == 0){
                return Container(
                  margin: EdgeInsets.only(top: 25,left: 20,bottom: 8),
                  child: Text("오늘의 캠핑 🌿",style: TextStyle(fontSize: 30,color: Colors.grey[800],fontWeight: FontWeight.bold),));
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
              }else if (index == 2){
                return Container(
                  width: 50,
                  height: 90,
                child: GridView.builder(
                  itemCount: recommendLocation.length, //item 개수
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                    childAspectRatio: 5/1, //item 의 가로 1, 세로 2 의 비율
                    mainAxisSpacing: 10, //수평 Padding
                    crossAxisSpacing: 10, //수직 Padding
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    //item 의 반목문 항목 형성
                    return GestureDetector(
                      onTap: (){
                        if(index == 0){
                          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> FilterDataPage(campData: campList,keywords:["강"])));

                        }else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ChatPage()));
                        }
                        print(index);
                        },
                      child: Card(
                        child: Container(
                          height: 100,
                          width: 100,
                            child: Center(
                              child: Text(
                                recommendLocation[index],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ),
                      ),
                    );
                    },
              ),
                );
              }
              return GestureDetector(
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
                  campList[index].intro.toString(),
                  130,130 //각 각 width,height
                ),
              );
            },
            separatorBuilder: (ctx, idx) {
              return _decorationWidgetBox.listMargin();
            },
            itemCount: campList.length),
    );
  }
}
