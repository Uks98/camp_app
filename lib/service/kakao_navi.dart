import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KaKaoNaviService {
  //카카오 네비가 기기에 설치되어있는지 확인합니다.
  void isCheckedInstallN({required String name, required String x,  required String y}) async {
    bool result = await NaviApi.instance.isKakaoNaviInstalled();
    if (result) {
      print('카카오내비 앱으로 길안내 가능');
      getKaKaoMove(name,x,y);
    } else {
      print('카카오내비 미설치');
      // 카카오내비 설치 페이지로 이동
      //launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
    }
    print("---------테스트 좌표 -- -- - - ");
    print(x);
    print(y);
  }

  //카카오 네비가 설치되어 있을 경우 해당 함수에서 카카오 네비를 호출합니다.
  void getKaKaoMove(String name, String x, String y) async {
    if (await NaviApi.instance.isKakaoNaviInstalled()) {
      // 카카오내비 앱으로 길 안내하기, WGS84 좌표계 사용
      await NaviApi.instance.navigate(
        destination:
            Location(name: '카카오 판교오피스', x: '127.108640', y: '37.402111'),
        // 경유지 추가
        viaList: [
          Location(name: '판교역 1번출구', x: '127.111492', y: '37.395225'),
        ],
      );
    } else {
      // 카카오내비 설치 페이지로 이동
      launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
    }
    print("카카오 네비 함수 on");
  }
}
