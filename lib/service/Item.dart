import 'package:flutter/material.dart';

class CampItem {

  //카라반,글램핑등에 대한 이미지가 저장된 리스트
  List<String> _campImageList = [
    "lib/asset/touring.png",
    "lib/asset/glamping.png",
    "lib/asset/caravan.png"
  ];
  //시설에 에 대한 이미지가 저장된 리스트
  List<String> _facilityList = [
    "lib/asset/mart.png",
    "lib/asset/toilet.png",
    "lib/asset/water.png",
    "lib/asset/shower.png",
    "lib/asset/swimming.png",
  ];
  //활동에 대한 이미지가 저장된 리스트
  List<String> _activityList = [
    "lib/asset/pets.png",
    "lib/asset/fishing.png",
  ];

  double _wid = 20.0; //위젯 width 사이즈 조절 변경이 용의하게 끔 변수생성

  // restApi에서 받아오는 데이터가 0일 경우 부지 운영을 따로 안한다는 경우
  // 0보다 클 경우는 부지 운영을 하는 경우
  Widget kindOfCamp(String autoSiteCo, String glamping, String caravSite) {
    //autosite -> 자동차 야영장부지
    //glam -> 글램핑부지
    //caravan -> 카라반 여행부지
    int auto = int.parse(autoSiteCo);
    int glam = int.parse(glamping);
    int caravn = int.parse(caravSite);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          auto > 0 ?Column(
            children: [
              Image.asset(
                _campImageList[0],
                height: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "오토캠핑",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ): Container(),
          auto >= 0 ?SizedBox(
            width: 20,
          ) : SizedBox(width: _wid,),
          glam > 0 ? Column(
            children: [
              Image.asset(
                _campImageList[1],
                height: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "글램핑",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ) : Container(),
          caravn > 0 ? Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Image.asset(
                  _campImageList[2],
                  height: 50,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "카라반",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget kindOfFacility(String freecon,String toilets,String shower1) {
    int toilet = int.parse(toilets); // int 변환
    int shower = int.parse(shower1); // int 변환
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          freecon.contains("마트") ?Column(
            children: [
              Image.asset(
                _facilityList[0],
                height: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "마트",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: _wid,
              ),
            ],
          ): Container(),
          !freecon.contains("마트") ? Container() : SizedBox(width: 20,),
          toilet > 0? Column(
            children: [
              Image.asset(
                _facilityList[1],
                height: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "화장실",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: _wid,
              ),
            ],
          ) : Container(),
          SizedBox(
            width: _wid,
          ),
          freecon.contains("온수") ? Column(
            children: [
              Image.asset(
                _facilityList[2],
                height: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "온수",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: _wid,
              ),
            ],
          ) : Container(),
          SizedBox(
            width: _wid,
          ),
          shower > 0 ? Column(
            children: [
              Image.asset(
                _facilityList[3],
                height: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "샤워장",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: _wid,
              ),
            ],
          ) : Container(),
          freecon.contains("수영장") ? Column(
            children: [
              Image.asset(
                _facilityList[4],
                height: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "수영장",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: _wid,
              ),
            ],
          ) : Container(),
        ],
      ),
    );
  }

  Widget kindOfActivity(String freecon2,String posblFcltyCl,String intro) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          freecon2.contains("반려") || intro.contains("반려견") ?Column(
            children: [
              Image.asset(
                _activityList[0],
                height: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "반려견",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: _wid,
              ),
            ],
          ): Container(),
          !freecon2.contains("반려")? SizedBox(width: 0,) : SizedBox(width: 20,),
          posblFcltyCl.contains("낚시") || intro.contains("낚시") ? Column(
            children: [
              Image.asset(
                _activityList[1],
                height: 40,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: _wid,
              ),
              Text(
                "낚시",
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                width: _wid,
              ),
            ],
          ) : Container(),
        ],
      ),
    );
  }
}
