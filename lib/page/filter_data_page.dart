import 'package:camper/widget/widget_box.dart';
import 'package:flutter/material.dart';

import '../data/camp_data.dart';

class FilterDataPage extends StatefulWidget {
  List<CampData> campData;

  //필터될 키워드
  List<String> keywords;

  FilterDataPage({Key? key, required this.campData, required this.keywords})
      : super(key: key);

  List<CampData> get campList => campData;

  @override
  State<FilterDataPage> createState() => _FilterDataPageState();
}

class _FilterDataPageState extends State<FilterDataPage> {
  WidgetBox _widgetBox = WidgetBox();

  //json data 내 특정 키워드를 뽑아 리스트로 만듦
  List<CampData> filterCampList = [];

  List<CampData> findMatchingWords(
      List<CampData> campData, List<String> targetWords) {
    List<CampData> filterList = [];
    for (final word in campData) {
      for (String target in targetWords) {
        if (word.mainIntro!.contains(target)) {
          filterList.add(word);
        }
      }
    }
    return filterList;
  }

  Future<void> filterDataList() async {
    filterCampList = await findMatchingWords(widget.campList, widget.keywords);
    setState(() {});
    for (final x in filterCampList) {
      print("xx x : ${x.mainIntro}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return _widgetBox.filterCampBox(
                      filterCampList[index].firstImageUrl.toString(),
                      filterCampList[index].campName.toString(),
                      filterCampList[index].address.toString(),
                      filterCampList[index].intro.toString());
                },
                separatorBuilder: (context, idx) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemCount: filterCampList.length),
          )
        ],
      ),
    );
  }
}
