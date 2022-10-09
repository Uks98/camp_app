import 'dart:convert';

import 'package:camper/data/camp_data.dart';
import 'package:camper/page/search_keyword_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.campData}) : super(key: key);
  CampData campData;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _noImage = "http://sanpo.pfmall.co.kr/img/no-image.png";
  CampData get campDataG{
    return widget.campData;
  }
  List? data = [];
  String? imageUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageData(campDataG.campId.toString());
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Container(
                height: 350,
                child:
                CarouselSlider.builder(
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int itemIndex, int _) =>
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) ),
                          image: DecorationImage(
                              image: data!.length <= 0 ? NetworkImage(_noImage) : NetworkImage(data![itemIndex]["imageUrl"]), fit: BoxFit.fill),),
                      ),
                  options: CarouselOptions(
                    height: 350,
                    viewportFraction:1,
                    initialPage: 1,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayCurve: Curves.easeInOut,
                    enlargeCenterPage: true,
                  autoPlay: true, //자동재생 여부
                ),
                )

              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getImageData(String id) async {
    var url = "https://apis.data.go.kr/B551011/GoCamping/imageList?serviceKey=iwOI%2BU0JCUIMem0fddRQ9Y4Fj2E254wSmoXLGM3hVwqHiS8h12%2FqNozM62Kb5D4ihpeW4KWouAt%2B9djISlDJzw%3D%3D&numOfRows=10&pageNo=1&MobileOS=AND&MobileApp=AppTest&_type=json&contentId=$id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        var dartConvertedToJson = json.decode(response.body);
        List result = dartConvertedToJson["response"]["body"]["items"]["item"];
        print(result);
        data?.addAll(result);
      });
      return response.body;
    } else {
      return "";
    }
  }

}
