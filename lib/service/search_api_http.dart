import 'dart:convert';

import 'package:camper/data/camp_data.dart';
import 'package:camper/data/search_camp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/camp_data.dart';


class SearchCampApi{
  List<SearchCamp> searchCampList = [];
  String _key = "iwOI%2BU0JCUIMem0fddRQ9Y4Fj2E254wSmoXLGM3hVwqHiS8h12%2FqNozM62Kb5D4ihpeW4KWouAt%2B9djISlDJzw%3D%3D";
  Future<List<SearchCamp>?> getSearchCampList({required BuildContext context,required String search}) async {
    var url = "https://apis.data.go.kr/B551011/GoCamping/searchList?numOfRows=10&pageNo=10&MobileOS=AND&MobileApp=A&serviceKey=$_key&_type=json&keyword=$search";
    var response = await http.get(Uri.parse(url));
    print(response);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      print(body);
      var res = json.decode(body) as Map<String,dynamic>;
      for (final _res in res["response"]["body"]["items"]["item"]) {
        final m = SearchCamp.fromJson(_res as Map<String, dynamic>);
        searchCampList.add(m);
      }
    }
    return searchCampList;
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
