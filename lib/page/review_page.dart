import 'package:camper/data/camp_data.dart';
import 'package:camper/service/realtimebase.dart';
import 'package:camper/service/review_service.dart';
import 'package:camper/widget/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../data/review.dart';
import '../widget/chart_widget.dart';

class ReviewPage extends StatefulWidget {
  CampData campData;
  final String? id;

  ReviewPage({Key? key, required this.campData, required this.id})
      : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  RealTimeBase _realTimeBase = RealTimeBase();
  TextFieldBox _textFieldBox = TextFieldBox();
  ReviewLogic _reviewLogic = ReviewLogic();
  List<Review> review = List.empty(growable: true);
  TextEditingController reviewController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  SharedPreferences? pref;

  //차트 카운터 저장
  // void saveChartState(String name,double count)async{
  // pref = await SharedPreferences.getInstance(); //sharedPreference
  // pref?.setDouble(name,count);
  // }
  // void getData(){
  //   starPeople5 =
  // }
  double check = 1;

  List<String> starPeoples5 = [];
  double? starPeople1 = 0; //1점 준 사람 수
  double? starPeople2 = 0;
  double? starPeople3 = 0;
  double? starPeople4 = 0;
  double? starPeople5 = 0; //5점 준 사람 수
  double serviceCheck = 1;
  String mainRef = "camp";
  String subRef = "review";
  var average = 0;

  double? rating; //차트에 사용되는 평점 변수 입니다.
  var ratingChart; //차트에 사용되는 평점 변수 입니다.

  List<double> s = [];

  CampData get campData {
    return widget.campData;
  }

  void deleteReview(int index) {
    if (review[index].id == user!.uid) {
      _realTimeBase.reference!
          .child(mainRef)
          .child(
            campData.campId.toString(),
          )
          .child(subRef)
          .child(user!.uid)
          .remove();
      setState(() {
        review.removeAt(index);
      });
    }
  }
  void initRealTimebase(){
    _realTimeBase.database;
    _realTimeBase.reference = _realTimeBase.database!.reference().child("camp");
    if (_realTimeBase.database != null) {
      _realTimeBase.reference!
          .child(mainRef)
          .child(widget.campData.campId!)
          .child(subRef)
          .onChildAdded
          .listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            review.add(Review.fromSnapshot(event.snapshot));
          });
        } else {
          return print("error in null");
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    re(review);
    initRealTimebase();
  //  readListLen();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    reviewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.grey[800],
          ),
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                    //키보드 창 위에 표시
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
                    height: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 43.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                campData.campName.toString(), //캠핑장 이름
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(campData.address.toString(), //캠핑주소
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("친절도"),
                            RatingBar.builder(
                              itemSize: 30,
                              initialRating: 0,
                              minRating: check,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  check = rating;
                                });
                                print("체크${check}");
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("청결도"),
                            RatingBar.builder(
                              itemSize: 30,
                              initialRating: 0,
                              minRating: serviceCheck,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  serviceCheck = rating;
                                });
                                print("serviceCheck ${serviceCheck}");
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                              width: 350,
                              child: _textFieldBox.contentField(
                                  reviewController, 3, 3)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            width: 350,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black),
                              onPressed: () {
                                if (_realTimeBase.reference != null &&
                                    reviewController.text.isNotEmpty) {
                                  String formatDate = DateFormat('MM월/dd일')
                                      .format(DateTime.now());
                                  //format변경
                                  setState(() {
                                    Review review = Review(
                                        user!.uid,
                                        reviewController.text,
                                        formatDate,
                                        check.floor(),
                                        serviceCheck.floor());
                                    _realTimeBase.reference!
                                        .child(mainRef)
                                        .child(widget.campData.campId!)
                                        .child(subRef)
                                        .child(user!.uid)
                                        .set(review.toJson());
                                  });
                                }
                                Navigator.of(context).maybePop();
                              },
                              child: Text("입력"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey[800],
                ))
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1.0,
          title: Text(
            "${campData.campName}",
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 200,
                          color: Colors.grey[50]),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${campData.campName}",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "별점 평균",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "리뷰${review.length}개",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "$average/5",
                            style: TextStyle(fontSize: 35),
                          ),
                          Container(
                              width: 200,
                              height: 300,
                              child: BarChart(
                                BarChartData(
                                  barGroups: barGroups,
                                  gridData: FlGridData(show: false),
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 100,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: false,
                  itemBuilder: (context, index1) {
                    re(review);
                    if (index1 == 0) {}
                    if (review[index1].disable2! >= 5) {
                      for(final x in starPeoples5){
                        print("프린트해줘${x}");
                      }
                      readListLen(review[index1].disable1.toString());
                    } else {

                    }
                    print("리뷰 몇점?${review[index1].disable2.toString()}");
                    return GestureDetector(
                      onTap: () {
                        deleteReview(index1);
                      },
                      child: Card(
                        child: InkWell(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 10),
                            child: Column(
                              children: [
                                Container(
                                  width: 350,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "캠퍼${index1 + 1}",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${review[index1].createTime.toString()}",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "${review[index1].review.toString()}",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      _reviewLogic.returnStar(
                                          review[index1].disable1!.floor()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, idx) {
                    return SizedBox(
                      height: 15,
                    );
                  },
                  itemCount: review.length),
            ),
          ],
        ));
  }

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(toY: review.length.toDouble()
                //gradient: [Colors.red],
                )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(toY: starPeople1!.toDouble(),
                //gradient: _barsGradient,
                )
          ],
          showingTooltipIndicators: [0],
        ),
        // BarChartGroupData(
        //   x: 2,
        //   barRods: [
        //     BarChartRodData(
        //       toY: 8,
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
        // BarChartGroupData(
        //   x: 3,
        //   barRods: [
        //     BarChartRodData(
        //       toY: 8,
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
        // BarChartGroupData(
        //   x: 4,
        //   barRods: [
        //     BarChartRodData(
        //       toY: 8,
        //       gradient: _barsGradient,
        //     )
        //   ],
        //   showingTooltipIndicators: [0],
        // ),
      ];

  void re(List revew){
    for(final x in revew){
      s.add(x.disable2!.toDouble());
      print("ssssss${starPeople1}");
      starPeople1 = s.length.toDouble();
    }
  }
  void readListLen(String review) {
    starPeoples5.add(review);
    //saveChartState("5",starPeople5!.toDouble());
    //starPeople5 = pref?.getDouble("5");
    print("명수 ${starPeoples5.length}");
  }
}
