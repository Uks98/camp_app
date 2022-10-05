import 'dart:convert';

import 'package:camper/data/camp_data.dart';
import 'package:camper/data/camp_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../data/camp_data.dart';
import '../data/camp_data.dart';
//import 'package:keyword_map/data/data.dart';

class CampApi{
  List<CampData> campData = [];
  Future<List<CampData>?> getCampList({required BuildContext context}) async {
    var url = "https://apis.data.go.kr/1471000/FoodNtrIrdntInfoService1/getFoodNtrItdntList1?serviceKey=iwOI%2BU0JCUIMem0fddRQ9Y4Fj2E254wSmoXLGM3hVwqHiS8h12%2FqNozM62Kb5D4ihpeW4KWouAt%2B9djISlDJzw%3D%3D&desc_kor=%EB%B0%94%EB%82%98%EB%82%98%EC%B9%A9&pageNo=1&numOfRows=3&bgn_year=2017&animal_plant=(%EC%9C%A0)%EB%8F%8C%EC%BD%94%EB%A6%AC%EC%95%84&type=json";
    var response = await http.get(Uri.parse(url));
    print(response);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var res = json.decode(body) as Map<String,dynamic>;
      if(res["body"]["items"][0] == ""){
        showDia(context);
      }
      for(final _res in res["body"]["items"][0]){
        final m = CampData.fromJson(_res as Map<String,dynamic>);
        campData.add(m);
      }
    }
    return campData;
  }
  void showDia(BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("🚨알림🚨"),
            content: Text("마지막 정보에요 😭"),
          );
        }
    );
  }
}


// class LocationClass{
//   static var longitude;
//   static var latitude;
//
//   void getLocation(BuildContext context) async {
//     LocationPermission per = await Geolocator.checkPermission();
//     if (per == LocationPermission.denied ||
//         per == LocationPermission.deniedForever) {
//       toastMessage(context,"위치를 허용해주세요");
//       LocationPermission per1 = await Geolocator.requestPermission();
//     } else {
//       Position currentLoc = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best);
//       toastMessage(context, "정보를 불러왔습니다.",);
//       longitude = currentLoc.longitude;
//       latitude = currentLoc.latitude;
//       print(longitude);
//       print(latitude);
//     }
//   }
//   void toastMessage(BuildContext context,String text){
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text),backgroundColor: Colors.white,));
//   }
// }