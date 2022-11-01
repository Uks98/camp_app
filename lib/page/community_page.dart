//게시판 이미지 해결ㅠ

//파이어스토어 set함수를 이용해 imagePicker에서 가져온 사진경로를 저장한다
//다음 작성하기 란에서 get 지역변수를 활용해 collection에 접근해 내가 원하는 속성값에 접근한다
//snapshot data의 doc에 길이를 지정한 리스트 뷰를 만들고 각 인덱스 값에 접근해 한 유저가 지정한 이미지가
//다른 유저의 이미지도 변경시키는 상황을 해결했다.




import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  Future _getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 650, maxHeight: 100);
    // 사진의 크기를 지정 650*100 이유: firebase는 유료이다.
    setState(() {
      pickedImage = File(pickedFile!.path);
    });
  }

  Future _uploadFile(BuildContext context,String url) async {
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
      if(firebaseStorageRef.getDownloadURL() == false){
        downloadUrl = "";
      }else{
        downloadUrl = await firebaseStorageRef.getDownloadURL();

      }
      // 문서 작성
      createDoc(fnName, fnDescription, content,downloadUrl);
     // await FirebaseFirestore.instance.collection(colName).doc(user!.uid).set({
     //   'imageUrl': downloadUrl,
     //   'userPhotoUrl': pickedImage!.path
     // });
    } catch (e) {
      print(e);
    }

    // 완료 후 앞 화면으로 이동
    Navigator.pop(context);
    print("down load ${downloadUrl}");
  }

  void createDoc(String name, String description, String content,String imageUrl) async {
    //final userData =  await FirebaseFirestore.instance.collection(colName).doc(user!.uid).get();
    FirebaseFirestore.instance.collection(colName).add({
      fnName: name,
      fnDescription: description,
      fnDatetime: Timestamp.now(),
      userId: user!.uid,
      content : content,
      'image_urls' : imageUrl,
      //userImage: userData['picked_image']
    });
   // print(userData["imageUrl"]);
  }

  // 컬렉션명
  String colName = "post";

  // 필드명
  final String fnName = "name";
  final String fnDescription = "location";
  final String fnDatetime = "datetime";
  final String imageUrl = "imageUrl";
  final String userId = "userId";
  final String content = "content";
  final String userImage = 'userImage';
  int _likeIndex = 0;
  String? url;
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
                    final docsList = snapshot.data!.docs;
                    if (snapshot.hasError)
                      return Text("Error: ${snapshot.error}");
                    else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );}else {
                      return snapshot.data != null
                          ? ListView.builder(
                          itemCount: docsList.length,
                          itemBuilder: (context,index){
                            return Stack(
                              children: [
                                Container(color: Colors.grey[900],),
                                Column(
                                  children: [
                                    Text(docsList[index]["name"]),
                                    Text(docsList[index]["location"]),
                                    SizedBox(height: 20,),
                                    Text(docsList[index]["userId"]),
                                  ],
                                ),
                                downloadUrl !=null
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: ClipRRect(
                                    child: Container(
                                      child:  downloadUrl == null ? Container() : Image.network( docsList[index]["image_urls"]),
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
                              ],
                            );
                          }) : const LinearProgressIndicator();
                    }
                  }),
            ),
          ),
        ],
      ),
    );
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
                    _uploadFile(context,downloadUrl);
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
                  onPressed: ()async{
                    _getImage();
                  },
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

  DateTime timestampToStrDateTime(Timestamp ts) {
    return DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch);}}