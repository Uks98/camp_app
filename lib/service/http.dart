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
    var url = "https://apis.data.go.kr/B551011/GoCamping/basedList?numOfRows=50&pageNo=1&MobileOS=AND&MobileApp=AAA&serviceKey=iwOI%252BU0JCUIMem0fddRQ9Y4Fj2E254wSmoXLGM3hVwqHiS8h12%252FqNozM62Kb5D4ihpeW4KWouAt%252B9djISlDJzw%253D%253D";
    var response = await http.get(Uri.parse(url),);
    if (response.statusCode == 200) {
      print(response);
      String body = utf8.decode(response.bodyBytes);
      var res = json.decode(body) as Map<String,dynamic>;
      if(res["response"]["body"]["items"]["item"] == ""){
        showDia(context);
      }
      for(final _res in res["response"]["body"]["items"]["item"]){
        final m = CampData.fromJson(_res as Map<String,dynamic>);
        campData.add(m);
      }
    }
    return campData;
  }
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
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