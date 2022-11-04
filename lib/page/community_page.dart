//게시판 이미지 해결ㅠ

//파이어스토어 set함수를 이용해 imagePicker에서 가져온 사진경로를 저장한다
//다음 작성하기 란에서 get 지역변수를 활용해 collection에 접근해 내가 원하는 속성값에 접근한다
//snapshot data의 doc에 길이를 지정한 리스트 뷰를 만들고 각 인덱스 값에 접근해 한 유저가 지정한 이미지가
//다른 유저의 이미지도 변경시키는 상황을 해결했다.
import 'dart:io';
import 'package:camper/color/color.dart';
import 'package:camper/widget/text_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Community extends StatefulWidget {
  Community({Key? key}) : super(key: key);

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void pickedImageFunc(File image) {
    pickedImage = image;
  }
  File? pickedImage;
  String downloadUrl = "a";
  DocumentSnapshot? documentSnapshot;
  final user = FirebaseAuth.instance.currentUser;
  final picker = ImagePicker();
  String time = ""; //firebase에 저장되는 시간
  TextFieldBox _textFieldBox = TextFieldBox();
  Future _getImage() async {
    if (pickedImage == null) {
      setState(() {
        pickedImage = File("");
      });
    } else {
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, maxWidth: 650, maxHeight: 100);
      // 사진의 크기를 지정 650*100 이유: firebase는 유료이다.
      setState(() {
        pickedImage = File(pickedFile!.path);
      });
    }
  }
  Future _uploadFile(
    BuildContext context, {
    required String url,
    required String time,
    required String titles,
    required String content,
  }) async {
    try {
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('picture')
          .child('${DateTime.now().millisecondsSinceEpoch}.png');

      // 파일 업로드
      final uploadTask = firebaseStorageRef.putFile(
          pickedImage!, SettableMetadata(contentType: 'image/png'));
      // 완료까지 기다림
      await uploadTask.whenComplete(() => null);
      // 업로드 완료 후 url
      if (firebaseStorageRef.getDownloadURL() == false) {
        downloadUrl = "";
      } else {
        downloadUrl = await firebaseStorageRef.getDownloadURL();
      }
      // 문서 작성
      createDoc(
          title: titles, content: content, imageUrls: downloadUrl, times: time);
    } catch (e) {
      print(e);
    }

    // 완료 후 앞 화면으로 이동
  }

  void createDoc(
      {required String title,
      required String content,
      required String imageUrls,
      required String times}) async {
    //final userData =  await FirebaseFirestore.instance.collection(colName).doc(user!.uid).get();
    FirebaseFirestore.instance.collection(colName).add({
      titles: title,
      fnDatetime: Timestamp.now(),
      userId: user!.uid,
      contents: content,
      "time": time,
      'image_urls': imageUrls,
      //userImage: userData['picked_image']
    });
    // print(userData["imageUrl"]);
  }
  // 컬렉션명
  String colName = "post";

  // 필드명
  final String titles = "title";
  final String fnDatetime = "datetime";
  final String imageUrl = "imageUrl";
  final String userId = "userId";
  final String contents = "content";
  final String userImage = 'userImage';
  String? url;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  DocumentSnapshot? document;

  Widget _floatingPanel({required String title,required String content,required String dateTime}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 1.0,
              color: Colors.grey,
            ),
          ]),
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "게시글 작성하기",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 300,
            height: 50,
            child: TextField(
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.white,
              controller: _contentController,
              maxLines: 1,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  fillColor: Colors.black,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  hintText: "제목을 입력해주세요."),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 230,
            width: 300,
            child: _textFieldBox.contentField(_contentController,10,10)
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 300,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: ColorBox.backColor,
              ),
              onPressed: ()async{
                await _getImage();
              },
              child: Text("사진 추가하기"),
            ),
          ),
          Container(
            width: 300,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
              onPressed: () async{
                if (_titleController.text.isNotEmpty) {
                  DateTime date = DateTime.now();
                  String time = DateFormat("MM/dd일 HH시 mm분").format(date);
                  await _uploadFile(context,
                      url: downloadUrl,
                      time: time,
                      titles: _titleController.text,
                      content: _contentController.text
                  );
                }
                _titleController.clear();
                _contentController.clear();
                // DateTime date = DateTime.now();
                // time = DateFormat("MM/dd일 HH시 mm분").format(date);
                // _uploadFile(context,
                //     url: downloadUrl,
                //     time: time,
                //     title: _titleController.text,
                //     content: _contentController.text);
                // Navigator.of(context).pop();
              },
              child: Text("작성하기"),
            ),
          ),
        ],
      ),
    );
  }

  Widget openPanel({required String title,required String content,required String dateTime}) {
    return SlidingUpPanel(
      renderPanelSheet: false,
      margin: EdgeInsets.all(20),
      panel: _floatingPanel(title: title,content: content,dateTime: dateTime),
      backdropEnabled: true,
      minHeight: 50,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(colName)
                          .orderBy(fnDatetime, descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        final docsList = snapshot.data!.docs;
                        if (snapshot.hasError)
                          return Text("Error: ${snapshot.error}");
                        else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return snapshot.data != null
                              ? ListView.separated(
                                  itemCount: docsList.length,
                                  itemBuilder: (context, index) {
                                    DateTime date = DateTime.now();
                                    time = DateFormat("MM/dd일 HH시 mm분").format(date);
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Text(
                                                docsList[index]["title"],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              width: 240,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              child: Text(
                                                docsList[index]["content"],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                              width: 240,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  docsList[index]["time"],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700]),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: ClipRRect(
                                            child: Container(
                                              child: Image.network(
                                                docsList[index]["image_urls"],
                                                fit: BoxFit.cover,
                                              ),
                                              width: 100,
                                              height: 100,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Divider(
                                          thickness: 1,
                                          endIndent: 10,
                                          indent: 10,
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : const LinearProgressIndicator();
                        }
                      }),
                ),
              ),
            ],
          ),
          openPanel(dateTime: time, title: _titleController.text,content: _contentController.text)
        ],
      ),
    );
  }

  // 문서 삭제 (Delete)
  void deleteDoc(User user) {
    FirebaseFirestore.instance.collection(colName).doc(document!.id).delete();
  }

  DateTime timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch);
  }
}
