// import 'package:firebase_database/firebase_database.dart';
//
// class DisableInfo {
//   String? key;
//   int? disable1;
//   int? disable2;
//   String? id;
//   String? createTime;
//
//   DisableInfo(this.id, this.disable1, this.disable2, this.createTime);
//
//   DisableInfo.fromSnapshot(DataSnapshot snapshot){
//     final data = snapshot.value as Map?;
//     key = snapshot.key.toString();
//     if(data != null){
//       id = data['id'];
//       disable1 = data['disable1'];
//       disable2 = data['disable2'];
//       createTime = data['createTime'];
//     }
//   }
//
//   toJson() {
//     return {
//       'id': id,
//       'disable1': disable1,
//       'disable2': disable2,
//       'createTime': createTime,
//     };
//   }
// }