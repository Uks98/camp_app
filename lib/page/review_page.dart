import 'package:camper/data/camp_data.dart';
import 'package:camper/service/realtimebase.dart';
import 'package:camper/widget/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../data/review.dart';

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
  List<Review> review = List.empty(growable: true);
  TextEditingController reviewController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  double check = 1;
  double serviceCheck = 1;


  CampData get campData {
    return widget.campData;
  }

  void deleteReview(int index) {
    if (review[index].id == user!.uid) {
      _realTimeBase.reference!
          .child('camp')
          .child(
        campData.campId.toString(),
      )
          .child('review')
          .child(user!.uid)
          .remove();
      setState(() {
        review.removeAt(index);
      });
    }
  }

  Widget returnStar(int star) {
    double iconSize = 16.0;
    Color color = Colors.amber;
    switch (star) {
      case 1:
        return Row(
          children: [
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
      case 2:
        return Row(
          children: [
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
      case 3:
        return Row(
          children: [
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
      case 4:
        return Row(
          children: [
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
      case 5:
        return Row(
          children: [
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Icons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
    }
    return CircularProgressIndicator();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _realTimeBase.database;
    _realTimeBase.reference = _realTimeBase.database!.reference().child("camp");
    if (_realTimeBase.database != null) {
      _realTimeBase.reference!
          .child("camp")
          .child(widget.campData.campId!)
          .child('review')
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
    print("캠핑 이미지 : ${campData.firstImageUrl}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
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
                              campData.campName.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(campData.address.toString(),
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
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) =>
                                Icon(
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
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) =>
                                Icon(
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
                            style:
                            ElevatedButton.styleFrom(primary: Colors.black),
                            onPressed: () {
                              if (_realTimeBase.reference != null &&
                                  reviewController.text.isNotEmpty) {
                                String formatDate = DateFormat('MM월/dd일')
                                    .format(DateTime.now()); //format변경
                                setState(() {
                                  Review review = Review(
                                      user!.uid,
                                      reviewController.text,
                                      formatDate,
                                      check.floor(),
                                      serviceCheck.floor());
                                  _realTimeBase.reference!
                                      .child("camp")
                                      .child(widget.campData.campId!)
                                      .child('review')
                                      .child(user!.uid)
                                      .set(review.toJson());
                                });
                              }
                              //getCheckInfo();
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
          IconButton(onPressed: () {
            Navigator.of(context).pop();
          }, icon: Icon(Icons.close, color: Colors.grey[800],))
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
      body: review.isNotEmpty
          ? Column(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(width: MediaQuery.of(context).size.width,
                    height: 300, color: Colors.white,child: Image.network(
                      "${campData.firstImageUrl}"
                    ),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${campData.campName}",
                        style: TextStyle(fontSize: 18),
                      ),
                      //Text(b.toString()),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
                shrinkWrap: false,
                itemBuilder: (context, index1) {
                  int i = 0;
                  double b = 0;
                  if (b > 5) {
                    b = 5;
                  } else {
                    for (final x in review) {
                      b = (x.disable1!.floor() + x.disable2!.floor()) / i;
                    }
                  }
                  return GestureDetector(
                    onTap: () {
                      deleteReview(index1);
                    },
                    child: Card(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10),
                          child: Column(
                            children: [
                              Container(
                                width: 350,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "캠퍼",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${review[index1].createTime
                                              .toString()}",
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
                                    returnStar(review[index1].disable1!.floor())
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
      )
          : Center(
        child: Text(
          "아직 리뷰가 없어요! 첫 리뷰를 남겨주세요",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  double returnAverage(int x, int y) {
    return (x + y) / 2;
  }
}
