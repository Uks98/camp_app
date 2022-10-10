import 'package:firebase_database/firebase_database.dart';
class Review {
  String? id;
  String? review;
  String? createTime;

  Review(this.id, this.review, this.createTime);

  Review.fromSnapshot(DataSnapshot snapshot){
    final data = snapshot.value as Map?;
    if(data != null) {
      id = data['id'].toString();
      review = data['review'].toString();
      createTime = data['createTime'].toString();
    }
  }

  toJson() {
    return {
      'id': id,
      'review': review,
      'createTime': createTime,
    };
  }
}