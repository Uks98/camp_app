import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:camper/service/search_api_http.dart';
import 'package:camper/widget/widget_box.dart';
import 'package:flutter/material.dart';

import '../data/search_camp.dart';

class KeyWordPage extends StatefulWidget {
  String keyword;

  KeyWordPage({Key? key, required this.keyword}) : super(key: key);

  @override
  State<KeyWordPage> createState() => _KeyWordPageState();
}

class _KeyWordPageState extends State<KeyWordPage> {
  String _noImage = "http://sanpo.pfmall.co.kr/img/no-image.png";
  SearchCampApi _searchCampApi = SearchCampApi();
  List<SearchCamp> searchCampList = [];
  WidgetBox _widgetBox = WidgetBox();

  void getSearchCampData(String keyword) async {
    searchCampList = (await _searchCampApi.getSearchCampList(
        search: keyword, context: context))!;
    setState(() {});
  }

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSearchCampData(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: searchCampList.isEmpty ? Center(child: Text("정보가 없습니다"),):ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              children: [
                Container(
                  width: 310,
                  height: 50,
                  margin: EdgeInsets.only(left: 10, right: 20, top: 20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: "검색어를 입력해주세요",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        icon: Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: Icon(Icons.search))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                      KeyWordPage(keyword: _searchController.text,)
                      ));
                      getSearchCampData(_searchController.text);
                      print(_searchController.text);
                    },
                    child: Text(
                      "검색",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            );
          }
          return _widgetBox.searchCampBox(
              // ignore: unnecessary_null_comparison
              searchCampList[index].firstImageUrl1.toString() == ""
                  ? _noImage
                  : searchCampList[index].firstImageUrl1.toString(), //썸네일
              searchCampList[index].campName1.toString(),
              searchCampList[index].address1.toString(),
              searchCampList[index].intro1.toString(),
              () {});

        },
        separatorBuilder: (BuildContext context, int index) {
          return Column(children: [
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(
              height: 10,
            ),
          ]);
        },
        itemCount: searchCampList.length,
      ),
    );
  }
}
