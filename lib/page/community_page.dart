import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File? pickedImage;
  DocumentSnapshot? documentSnapshot;
  String? url;
  final user = FirebaseAuth.instance.currentUser;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);
    setState(() {
      if (pickedImageFile != null) {
        pickedImage = File(pickedImageFile.path);
      }
    });
    addImageFun(pickedImage!);
  }

  void addImageFun(File pickedImage) {}

  // 컬렉션명
   String colName = "FirstDemo";

  // 필드명
  final String fnName = "name";
  final String fnDescription = "location";
  final String fnDatetime = "datetime";
  final String imageUrl = "imageUrl";
  final String userId = "userId";
  final String userImage = 'userImage';
   int _likeIndex = 0;

  TextEditingController _newNameCon = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _undNameCon = TextEditingController();
  TextEditingController _undDescCon = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  DocumentSnapshot? document;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: showCreateDocDialog,
        child: Icon(Icons.add),
        backgroundColor: Color(0xff82A284),
      ),
      body: Column(
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
                    if (snapshot.hasError)
                      return Text("Error: ${snapshot.error}");
                    else {
                      return snapshot.data != null
                          ? ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          DateTime dt = DateTime.now();
                          final time = DateFormat("yyyy/MM/dd일 HH시 mm분")
                              .format(dt);
                          return GestureDetector(
                            onTap: () {
                              showUpdateOrDeleteDocDialog(
                                  document);
                            },
                            child: Card(
                              elevation: 3,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                child: Row(
                                  children: <Widget>[
                                    pickedImage != null
                                        ? Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: ClipRRect(
                                        child: Container(
                                          child: Image.file(
                                            File(pickedImage!
                                                .path),
                                            fit: BoxFit.cover,
                                          ),
                                          width: 150,
                                          height: 150,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(
                                            30),
                                      ),
                                    )
                                        : Container(
                                      color: Colors.redAccent,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 19.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Text(
                                            document["name"],
                                            style: const TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '위치: ${document["location"]}',
                                              style: const TextStyle(
                                                  color: Colors.black54,fontSize: 17),
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Container(
                                            width: 200,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${document["content"]}',
                                              style: const TextStyle(
                                                color: Colors.black54,fontSize: 15,),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Container(
                                            width: 200,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '${document["userId"]}',
                                              style: const TextStyle(
                                                color: Colors.black54,fontSize: 15,),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                            ),
                                          ),
                                          Container(
                                            width: 200,
                                            child: Text(
                                              time,
                                              style: TextStyle(
                                                  color: Colors.grey[600]),
                                            ),
                                          ),
                                          document["userId"] == user!.uid ? Column(
                                            children: [
                                            GestureDetector(
                                              onTap : (){
                                                setState((){
                                                  updateDoc(doc: document, count: _likeIndex + 1);
                                                });
                                                print(_likeIndex);
                                              },
                                                child: Icon(Icons.abc,size: 40,)),
                                              Text(_likeIndex.toString()),
                                            ],
                                          ) : Container()
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                          : const LinearProgressIndicator();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void createDoc(String name, String description, String content) async {
    //final userData =  await FirebaseFirestore.instance.collection(colName).doc(user!.uid).get();
    FirebaseFirestore.instance.collection(colName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      userId: user!.uid,
      'picked_image': url,
      'content': content,
      'like' : _likeIndex,
      //userImage: userData['picked_image']
    });
  }


  // 문서 갱신 (Update)
  void updateDoc(
      {required DocumentSnapshot doc, required int count}) {
    FirebaseFirestore.instance.collection(colName).doc(doc.id).update({
      'like' : count,
    });
  }

  // 문서 삭제 (Delete)
  void deleteDoc(User user) {
    FirebaseFirestore.instance.collection(colName).doc(document!.id).delete();
  }

  void showCreateDocDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.45,
          child: AlertDialog(
            contentPadding: EdgeInsets.all(20),
            insetPadding: EdgeInsets.zero,
            title: const Text("강아지를 찾아주세요!"),
            content: Container(
              height: 200,
              child: Column(
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(labelText: "제목"),
                    controller: _newNameCon,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "위치"),
                    controller: _locationController,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText: "내용",
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text("취소"),
                onPressed: () {
                  _newNameCon.clear();
                  _locationController.clear();
                  _contentController.clear();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(primary: Color(0xff947EC3)),
              ),
              ElevatedButton(
                child: Text("작성하기"),
                onPressed: () {
                  if (_locationController.text.isNotEmpty &&
                      _newNameCon.text.isNotEmpty) {
                    createDoc(_newNameCon.text, _locationController.text, _contentController.text);
                  }
                  _newNameCon.clear();
                  _locationController.clear();
                  _contentController.clear();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(primary: Color(0xff6A67CE)),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xffB689C0)),
                  onPressed: _pickImage,
                  child: Text("이미지 추가"))
            ],
          ),
        );
      },
    );
  }

  void showReadDocSnackBar(DocumentSnapshot doc) {
    _scaffoldKey.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrangeAccent,
          duration: Duration(seconds: 5),
          content: Text(
              "$fnName: ${doc[fnName]}\n$fnDescription: ${doc[fnDescription]}"
                  "\n$fnDatetime: ${timestampToStrDateTime(doc[fnDatetime])}"),
          action: SnackBarAction(
            label: "Done",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
  }

  void showUpdateOrDeleteDocDialog(DocumentSnapshot doc) {
    _undNameCon.text = doc[fnName];
    _undDescCon.text = doc[fnDescription];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("수정 및 삭제하기"),
          content: Container(
            height: 200,
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: "Name"),
                  controller: _undNameCon,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Description"),
                  controller: _undDescCon,
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text("취소"),
              onPressed: () {
                _undNameCon.clear();
                _undDescCon.clear();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("업데이트"),
              onPressed: () {
                if (_undNameCon.text.isNotEmpty &&
                    _undDescCon.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection(colName).doc(doc.id).update({
                    fnName: _newNameCon.text,
                    fnDescription: _locationController.text,
                    'content' : _contentController.text,
                  });
                  //updateDoc(doc: documentSnapshot.id, description:_undNameCon.text,content :_contentController.text, description: _undDescCon.text, name: '');
                }
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("삭제"),
              onPressed: () {
                FirebaseFirestore.instance.collection(colName).doc(doc.id).delete();
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("이미지 추가하기"),
              onPressed: () async {
                //이미지가 저장되는 클라우드 경로에 접근가능메서드
                final refImage = FirebaseStorage.instance
                    .ref()
                    .child('picked_image')
                    .child(user!.uid.toString() + '.png');
                await refImage.putFile(pickedImage!);
                url = await refImage.getDownloadURL();
              },
            )
          ],
        );
      },
    );
  }

  String timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch)
        .toString();
  }
}