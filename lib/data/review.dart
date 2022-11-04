import 'package:firebase_database/firebase_database.dart';
class Review {
  String? id;
  String? review;
  String? createTime;
  int? disable1;
  int? disable2;

  Review(this.id, this.review, this.createTime,this.disable1,this.disable2);

  Review.fromSnapshot(DataSnapshot snapshot){
    final data = snapshot.value as Map?;
    if(data != null) {
      id = data['id'].toString();
      review = data['review'].toString();
      createTime = data['createTime'].toString();
      disable1 = data['disable1'];
      disable2 = data['disable2'];
    }
  }

  toJson() {
    return {
      'id': id.toString(),
      'review': review,
      'createTime': createTime,
      'disable1': disable1,
      'disable2': disable2,
    };
  }
}
