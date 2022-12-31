import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewLogic{
  //리뷰 평점에 따라 별의 갯수를 반환하는 로직
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
  //문의 사항 전송 함수
  void sendEmail() {
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'rozyfactory@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': '오늘의 캠핑 의견 보내기',
        'body': '''많이 부족한 오늘의 캠핑을 이용해 주셔서 감사합니다.
          주신 의견을 토대로 발전해 나가겠습니다.'''
      }),
    );
    launch(emailLaunchUri.toString());
  }


}