import 'dart:convert';

import 'package:http/http.dart' as http;


class RecommendFilter{
  
  void getPet() async{
    var response = await http.get(Uri.parse("https://apis.data.go.kr/B551011/GoCamping/basedList?numOfRows=50&pageNo=1&MobileOS=AND&MobileApp=AAA&serviceKey=iwOI%2BU0JCUIMem0fddRQ9Y4Fj2E254wSmoXLGM3hVwqHiS8h12%2FqNozM62Kb5D4ihpeW4KWouAt%2B9djISlDJzw%3D%3D&_type=json"));
    var decode = jsonDecode(utf8.decode(response.bodyBytes));
    List data = decode["response"]["body"]["items"]["item"] as List;

    Iterable filterData = data.where((element) => element["intro"] == "담양");

    print("필터된 데이터 ${filterData}");
  }
}