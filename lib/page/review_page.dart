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

  //평점 변수
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
  var average = 4;

  double? rating; //차트에 사용되는 평점 변수 입니다.
  var ratingChart; //차트에 사용되는 평점 변수 입니다.

  List<double> s = [];

  CampData get campData {
    return widget.campData;
  }

  //리뷰 삭제 함수
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

  //초기화
  void initRealTimebase() {
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
    initRealTimebase();
    print("aaaaaaaaaaaa${user!.uid}");
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
                      //리뷰 페이지 사진
                      child: Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: 300,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              campData.firstImageUrl.toString(),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 300,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "캠핑 만족도",
                            style: TextStyle(fontSize: 28, color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "$average/5",
                            style: TextStyle(
                                fontSize: 33,
                                color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "작성된 리뷰 ${review.length}개",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
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
                                          //리뷰 작성 시간
                                          Text(
                                            "${review[index1].createTime.toString()}",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          //사용자 리뷰
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
}