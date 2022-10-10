import 'package:camper/data/camp_data.dart';
import 'package:camper/service/realtimebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/review.dart';

class ReviewPage extends StatefulWidget {
  CampData campData;
  final String? id;
  ReviewPage({Key? key, required this.campData,required this.id}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  RealTimeBase _realTimeBase = RealTimeBase();
  List<Review> review = List.empty(growable: true);
  TextEditingController reviewController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
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
          onPressed: () {
            print('아이디 : ${widget.id}');
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('후기 쓰기'),
                  content: TextField(
                    controller: reviewController,
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text("후기작성"),
                      onPressed: () {
                        if (_realTimeBase.reference != null &&
                            widget.campData.campId != null &&
                            reviewController.text.isNotEmpty) {
                          String formatDate = DateFormat('yy년 MM월 dd일 HH시 mm분').format(DateTime.now()); //format변경
                          Review review = Review(
                              user!.uid,
                              reviewController.text,
                              formatDate);
                          _realTimeBase.reference!
                              .child('camp')
                              .child(widget.campData.campId!)
                              .child('review').child(user!.uid)
                              .set(review.toJson());
                        }
                        Navigator.of(context).maybePop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            "리뷰",
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              print('리뷰 : ${review[index].review}');
              return Card(
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                    child: Text(
                      '익명${index + 1} : ${review[index].review} ${review[index].createTime}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, idx) {
              return SizedBox(
                height: 10,
              );
            },
            itemCount: review.length));
  }
}
