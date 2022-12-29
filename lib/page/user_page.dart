import 'package:camper/color/color.dart';
import 'package:camper/data/user_info_data.dart';
import 'package:camper/widget/widget_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserInfoData _userInfo = UserInfoData(); //유저 정보가 담긴 클래스
  WidgetBox _widgetBox = WidgetBox(); // 커스텀 위젯이 담긴 클래스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "마이 페이지",
          style: TextStyle(color: ColorBox.textColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: ColorBox.textColor,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                //bool isChecked = _userInfo.funUserCheck(UserInfoData.user!.uid);
                if (index == 0) {
                  final userInfo = UserInfoData.user;
                  return Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                        width: 300,
                        height: 100,
                        color: Colors.white,
                        child:_widgetBox.campingListWidget(
                            userInfo!.photoURL.toString(),
                            userInfo.displayName.toString(),
                            userInfo.email.toString(),
                            "",
                            100,
                            100)),
                  );
                } else if (index == 1) {
                  return Column(
                    children: [
                      Container(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                                if(index == 0) {
                                  return _widgetBox.userListTile(
                                      "ㅁㅁ", "subtitle", () {});
                                }else if(index == 1){
                                    return _widgetBox.userListTile(
                                        "ㅁㅁ", "a", () {});
                                }
                                return Container();

                          },
                          itemCount: 4,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                        height: 600,
                      ),
                    ],
                  );
                }
                return Container();
              },
              itemCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
