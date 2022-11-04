import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/camp_data.dart';
import '../page/review_page.dart';
import '../service/Item.dart';

class DetailWidget {
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
        Widget? googleMap}) {
    String _noImage = "http://sanpo.pfmall.co.kr/img/no-image.png";
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
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
                autoPlayInterval: Duration(seconds: 5),
                autoPlayCurve: Curves.easeInOut,
                enlargeCenterPage: true,
                autoPlay: true, //자동재생 여부
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  campName.toString(),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReviewPage(
                              campData: CampData(campId: campId,campName: campName,address: address),
                              id: ids!,
                            )));
                  },
                  child: Text(
                    "리뷰 작성하기",
                    style: TextStyle(fontSize: 18,color: Colors.grey[800]),
                  ),
                ),
                SizedBox(
                  height: 10,
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
                campG.kindOfActivity(freecon2.toString(), posblfclty.toString())
              ],
            ),
          )
        ],
      ),
    );
  }
}
