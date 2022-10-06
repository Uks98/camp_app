
class CampData {
  String? campId; //캠핑장 고유 아이디
  String? campName; //캠핑장 이름
  String? insrncAt; //책임 가입 여부
  String? feather; //캠핑장 특징
  String? address; //캠핑장 주소
  String? mapx; //경도
  String? mapy; //위도
  String? tel; //전화번호
  String? homePage; //홈페이지
  String? resveUrl; // 예약 홈페이지
  String? nomalSite; //주요시설 일반야영장
  String? autoSiteCo; //자동차 야영장
  String? glamping; //글램핑야영장
  String? caravSite; // 카라반 야영장
  String? glamInside; //글램핑 내부 시설
  String? caravanInside; //글램핑 내부 시설
  String? operPd; // 운영기간
  String? operDay; // 운영일
  String? intro; //캠핑장 짧은 소개
  String? mainIntro; // 캠핑장 장문 소개
  String? firstImageUrl; //캠핑장  썸네일
  String? toilet; //화장실 개수
  String? shower; //샤워실 개수
  String? wtrplCo; //개수대 개수
  String? freeCon; //부대시설
  String? freeCon2; //부대시설 기타
  String? posblFcltyCl; //주변이용가능시설
  String? ProgrmBool; //체험프로그램 여부(Y:사용, N:미사용)
  String? ProgrmName; //체험프로그램 이름
  String? extshrCo; //소화기 개수
  String? fireSensorCo; //화재감지기 개수
  String? thema; //테마환경

  CampData({
    this.campId,
    this.campName,
    this.insrncAt,
    this.feather,
    this.address,
    this.mapx,
    this.mapy,
    this.tel,
    this.homePage,
    this.resveUrl,
    this.nomalSite,
    this.autoSiteCo,
    this.glamping,
    this.caravSite,
    this.glamInside,
    this.caravanInside,
    this.operPd,
    this.operDay,
    this.intro,
    this.mainIntro,
    this.firstImageUrl,
    this.toilet,
    this.shower,
    this.wtrplCo,
    this.freeCon,
    this.freeCon2,
    this.posblFcltyCl,
    this.ProgrmBool,
    this.ProgrmName,
    this.extshrCo,
    this.fireSensorCo,
    this.thema,
  });

  factory CampData.fromJson(Map<String, dynamic> data) {
    return CampData(
        campId: data["contentId"].toString().toString(),
        campName: data["facltNm"].toString().toString(),
        insrncAt: data["insrncAt"].toString(),
        feather: data["featureNm"].toString(),
        address: data["addr1"].toString(),
        mapx: data["mapX"].toString(),
        mapy: data["mapY"].toString(),
        tel: data["tel"].toString(),
        homePage: data["homepage"].toString(),
        resveUrl: data["resveUrl"].toString(),
        nomalSite: data["gnrlSiteCo"].toString(),
        autoSiteCo: data["autoSiteCo"].toString(),
        glamping: data["glampSiteCo"].toString(),
        caravSite: data["caravSiteCo"].toString(),
        glamInside: data["glampInnerFclty"].toString(),
        caravanInside: data["caravInnerFclty"].toString(),
        operPd: data["operPdCl"].toString(),
        operDay: data["operDeCl"].toString(),
        intro: data["lineIntro"].toString(),
        mainIntro: data["intro"].toString(),
        firstImageUrl: data["firstImageUrl"].toString(),
        toilet: data["toiletCo"].toString(),
        shower: data["swrmCo"].toString(),
        wtrplCo: data["wtrplCo"].toString(),
        freeCon: data["sbrsCl"].toString(),
        freeCon2: data["sbrsEtc"].toString(),
        posblFcltyCl: data["posblFcltyCl"].toString(),
        ProgrmBool: data["exprnProgrmAt	"].toString(),
        ProgrmName: data["exprnProgrm"].toString(),
        extshrCo: data["extshrCo"].toString(),
        fireSensorCo: data["fireSensorCo"].toString(),
        thema: data["themaEnvrnCl"].toString());
  }
}
