import 'package:firebase_auth/firebase_auth.dart';

class UserInfoData {
  static var user = FirebaseAuth.instance.currentUser; //사용자 토큰 값 가져오는 변수
  static bool isCheck = true;
  final _authentication = FirebaseAuth.instance;
}