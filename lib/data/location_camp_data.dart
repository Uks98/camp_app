
import 'dart:convert';
import 'dart:io';
import 'package:camper/service/location.dart';
import 'package:http/http.dart' as http;
class LocationCampData {
  String? campId1; //캠핑장 고유 아이디
  String? campName1; //캠핑장 이름
  String? insrncAt1; //책임 가입 여부
  String? feather1; //캠핑장 특징
  String? address1; //캠핑장 주소
  String? mapx1; //경도
  String? mapy1; //위도
  String? tel1; //전화번호
  String? homePage1; //홈페이지
  String? resveUrl1; // 예약 홈페이지
  String? nomalSite1; //주요시설 일반야영장
  String? autoSiteCo1; //자동차 야영장
  String? glamping1; //글램핑야영장
  String? caravSite1; // 카라반 야영장
  String? glamInside1; //글램핑 내부 시설
  String? caravanInside1; //글램핑 내부 시설
  String? operPd1; // 운영기간
  String? operDay1; // 운영일
  String? intro1; //캠핑장 짧은 소개
  String? mainIntro1; // 캠핑장 장문 소개
  String? firstImageUrl1; //캠핑장  썸네일
  String? toilet1; //화장실 개수
  String? shower1; //샤워실 개수
  String? wtrplCo1; //개수대 개수
  String? freeCon1; //부대시설
  String? freeCon21; //부대시설 기타
  String? posblFcltyCl1; //주변이용가능시설
  String? ProgrmBool1; //체험프로그램 여부(Y:사용, N:미사용)
  String? ProgrmName1; //체험프로그램 이름
  String? extshrCo1; //소화기 개수
  String? fireSensorCo1; //화재감지기 개수
  String? thema1; //테마환경

  LocationCampData({
    this.campId1,
    this.campName1,
    this.insrncAt1,
    this.feather1,
    this.address1,
    this.mapx1,
    this.mapy1,
    this.tel1,
    this.homePage1,
    this.resveUrl1,
    this.nomalSite1,
    this.autoSiteCo1,
    this.glamping1,
    this.caravSite1,
    this.glamInside1,
    this.caravanInside1,
    this.operPd1,
    this.operDay1,
    this.intro1,
    this.mainIntro1,
    this.firstImageUrl1,
    this.toilet1,
    this.shower1,
    this.wtrplCo1,
    this.freeCon1,
    this.freeCon21,
    this.posblFcltyCl1,
    this.ProgrmBool1,
    this.ProgrmName1,
    this.extshrCo1,
    this.fireSensorCo1,
    this.thema1,
  });

  factory LocationCampData.fromJson(Map<String, dynamic> data) {
    return LocationCampData(
        campId1: data["contentId"].toString().toString(),
        campName1: data["facltNm"].toString().toString(),
        insrncAt1: data["insrncAt"].toString(),
        feather1: data["featureNm"].toString(),
        address1: data["addr1"].toString().padRight(5),
        mapx1: data["mapX"].toString(),
        mapy1: data["mapY"].toString(),
        tel1: data["tel"].toString(),
        homePage1: data["homepage"].toString(),
        resveUrl1: data["resveUrl"].toString(),
        nomalSite1: data["gnrlSiteCo"].toString(),
        autoSiteCo1: data["autoSiteCo"].toString(),
        glamping1: data["glampSiteCo"].toString(),
        caravSite1: data["caravSiteCo"].toString(),
        glamInside1: data["glampInnerFclty"].toString(),
        caravanInside1: data["caravInnerFclty"].toString(),
        operPd1: data["operPdCl"].toString(),
        operDay1: data["operDeCl"].toString(),
        intro1: data["lineIntro"].toString(),
        mainIntro1: data["intro"].toString(),
        firstImageUrl1: data["firstImageUrl"].toString(),
        toilet1: data["toiletCo"].toString(),
        shower1: data["swrmCo"].toString(),
        wtrplCo1: data["wtrplCo"].toString(),
        freeCon1: data["sbrsCl"].toString(),
        freeCon21: data["sbrsEtc"].toString(),
        posblFcltyCl1: data["posblFcltyCl"].toString(),
        ProgrmBool1: data["exprnProgrmAt	"].toString(),
        ProgrmName1: data["exprnProgrm"].toString(),
        extshrCo1: data["extshrCo"].toString(),
        fireSensorCo1: data["fireSensorCo"].toString(),
        thema1: data["themaEnvrnCl"].toString());
  }
}

class LocationMarkerInfo {
  //ItemList => 위도 경도 담고있는 클래스
  List<LocationCampData>? offices1;

  LocationMarkerInfo({required this.offices1});

  LocationMarkerInfo.fromJson(Map<String, dynamic> json) {
    //해당 키 값에 접근하기 위해 작성
    if (json["response"]["body"]["items"]["item"] != null) {
      offices1 = <LocationCampData>[];
      json["response"]["body"]["items"]["item"].forEach((v) {
        offices1!.add(new LocationCampData.fromJson(v));
      });
    }
    print("office : ${offices1}");
  }
}

Future<LocationMarkerInfo> getGoogleOffices2() async {
  String _x = LocationClass.latitude.toString();
  String _y =LocationClass.longitude.toString();
  String _key = "iwOI%2BU0JCUIMem0fddRQ9Y4Fj2E254wSmoXLGM3hVwqHiS8h12%2FqNozM62Kb5D4ihpeW4KWouAt%2B9djISlDJzw%3D%3D";
  // 위도 경도가 서로 다름..
  var googleLocationsURL = 'https://apis.data.go.kr/B551011/GoCamping/locationBasedList?serviceKey=$_key&numOfRows=10&pageNo=1&MobileOS=AND&MobileApp=App&_type=json&mapX=$_y&mapY=$_x&radius=20000';
  final response = await http.get(Uri.parse(googleLocationsURL));
  if (response.statusCode == 200) {
    print("body : ${response.body}");
    //Map<String,dynamic>형식으로 저장
    return LocationMarkerInfo.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
            ' ${response.reasonPhrase}',
        uri: Uri.parse(googleLocationsURL));
  }
}

