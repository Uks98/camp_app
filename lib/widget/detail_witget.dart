import 'dart:ffi';

import 'package:camper/service/kakao_navi.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/camp_data.dart';
import '../page/review_page.dart';
import '../service/Item.dart';

class DetailWidget {
  int vaIndex = 0;
  Widget drawCampDetail(
      {required String campId,
      required String campName,
      required String address,
      required String freeCon,
      required String mainIntro,
      required String autoSite,
      required String glamping,
      required String caravanSite,
      toilet,
      shower,
      freecon2,
      posblfclty,
      required var ids,
      required List data,
      required CampItem campG,
      required BuildContext context,
        Widget? googleMap,
        required String x,
        required String y,
        required firstImage
      }) {
    KaKaoNaviService _kaKaoNaviService = KaKaoNaviService();
    String _noImage = "http://sanpo.pfmall.co.kr/img/no-image.png";
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 280,
            child: CarouselSlider.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int itemIndex, int _) =>
                  Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                     // bottomLeft: Radius.circular(5),
                     // bottomRight: Radius.circular(5)
                  ),
                  image: DecorationImage(
                      image: data.length <= 0
                          ? NetworkImage(_noImage)
                          : NetworkImage(data[itemIndex]["imageUrl"]),
                      fit: BoxFit.fill),
                ),
              ),
              options: CarouselOptions(
                height: 350,
                viewportFraction: 1,
                initialPage: 0,
                autoPlayInterval: Duration(seconds: 7),
                autoPlayCurve: Curves.easeInOut,
                enlargeCenterPage: true,
                autoPlay: true, //자동재생 여부
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.only(left: 13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  campName.toString(),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>  ReviewPage(
                              campData: CampData(campId : campId,campName: campName,address: address,firstImageUrl:firstImage),
                              id: ids!,
                            )));
                      },
                      child: Text(
                        "전체 리뷰 보기 🖍️".toString(),
                        style: TextStyle(fontSize: 16,color: Colors.grey[500]),
                      ),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                    TextButton(
                      onPressed: (){
                        _kaKaoNaviService.isCheckedInstallN(name: campName,x: x,y: y);
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        "경로 찾기 🏕️".toString(),
                        style: TextStyle(fontSize: 16,color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  address.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                  endIndent: 30,
                  indent: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "캠핑장 설명",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.only(left: 0, right: 15),
                    child: Text(mainIntro.toString(),
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w200,
                            color: Colors.grey[700]))),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 1,
                  endIndent: 30,
                  indent: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "위치",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  address.toString(),
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
               // if(campG != null)
               googleMap!,
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 1,
                  endIndent: 30,
                  indent: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "캠핑장 유형",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    campG.kindOfCamp(
                      autoSite.toString(),
                      glamping.toString(),
                      caravanSite.toString(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                  endIndent: 30,
                  indent: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "보유 시설",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                campG.kindOfFacility(
                  freeCon.toString(),
                  toilet.toString(),
                  shower.toString(),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                  endIndent: 30,
                  indent: 5,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "프로그램 및 활동",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                campG.kindOfActivity(freecon2.toString(), posblfclty.toString(),mainIntro.toString()),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
