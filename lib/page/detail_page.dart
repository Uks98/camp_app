import 'dart:convert';

import 'package:camper/data/camp_data.dart';
import 'package:camper/page/review_page.dart';
import 'package:camper/page/search_keyword_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../service/Item.dart';
class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.campData}) : super(key: key);
  CampData campData;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _noImage = "http://sanpo.pfmall.co.kr/img/no-image.png";
  var ids;
  CampItem _campItem = CampItem();
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
    ids = ModalRoute.of(context)!.settings.arguments.toString();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
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
                      initialPage: 0,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayCurve: Curves.easeInOut,
                      enlargeCenterPage: true,
                    autoPlay: true, //자동재생 여부
                  ),
                  ),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text(campDataG.campName.toString(),style: TextStyle(fontSize: 20),),
                      SizedBox(height: 10,),
                      TextButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ReviewPage(
                          campData: CampData(campId: campDataG.campId),
                          id: ids!,
                        )));
                      }, child: Text("리뷰 수 ",style: TextStyle(fontSize: 18),),),
                      SizedBox(height: 10,),
                      Text(campDataG.address.toString(),style: TextStyle(fontSize: 14,color: Colors.grey[700]),),
                      SizedBox(height: 10,),
                      Divider(thickness: 1,endIndent: 30,indent: 5,),
                      SizedBox(height: 10,),
                      Text("캠핑장 설명",style: TextStyle(fontSize: 18,),),
                      SizedBox(height: 20,),
                      Container(
                          margin: EdgeInsets.only(left: 5,right: 15),
                          child: Text(campDataG.mainIntro.toString(),style: TextStyle(fontSize: 14,letterSpacing: 1.0,fontWeight: FontWeight.w200))),
                      SizedBox(height: 20,),
                      Divider(thickness: 1,endIndent: 30,indent: 5,),
                      SizedBox(height: 20,),
                      Text("위치",style: TextStyle(fontSize: 18,),),
                      SizedBox(height: 20,),
                      Divider(thickness: 1,endIndent: 30,indent: 5,),
                      SizedBox(height: 10,),
                      Text("캠핑장 유형",style: TextStyle(fontSize: 18,),),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 5,),
                          _campItem.kindOfCamp(campDataG.autoSiteCo.toString(), campDataG.glamping.toString(),campDataG.caravSite.toString(),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(thickness: 1,endIndent: 30,indent: 5,),
                      SizedBox(height: 10,),
                      Text("보유 시설",style: TextStyle(fontSize: 18,),),
                      SizedBox(height: 20,),
                      _campItem.kindOfFacility(campDataG.freeCon.toString(),campDataG.toilet.toString(),campDataG.shower.toString(),),
                      SizedBox(height: 10,),
                      Divider(thickness: 1,endIndent: 30,indent: 5,),
                      SizedBox(height: 10,),
                      Text("프로그램 및 활동",style: TextStyle(fontSize: 18,),),
                      SizedBox(height: 20,),
                      _campItem.kindOfActivity(campDataG.freeCon2.toString(),campDataG.posblFcltyCl.toString())

                    ],
                  ),
                )
              ],
            ),
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
