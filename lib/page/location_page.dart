import 'dart:async';

import 'package:camper/color/color.dart';
import 'package:camper/data/location_camp_data.dart' as location_Marker;
import 'package:camper/widget/widget_box.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../data/camp_data.dart';
import '../data/location_camp_data.dart';
import '../service/location.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  int _count = 0;
  int _bottomCount = 0;
  LocationClass locationClass = LocationClass();
  WidgetBox _widgetBox = WidgetBox();
  final Map<String, Marker> _markers = {};

  String? _locationText;

  String get keyword => this.keyword;
  List<CampData> locationData =
      []; // Futuer list<LocationMapData>에서 반환한 리스트 받아오기
  List<Map<String, List<double>>> locations = [
    {
      "내위치": [LocationClass.latitude, LocationClass.longitude],
    },
    {
      "가평": [127.5098827, 37.8315403],
    },
    {
      "태안": [126.36836650697, 36.473491829673],
    },
    {
      "서귀포": [126.260719, 33.221472]
    }
  ]; // 캠핑지로 유명한 지역 리스트 사용자 위치 변경
  List<String> campKind = ["글램핑", "오토캠핑", "카라반"];
  int _locationCount = 0;
  double latitude = LocationClass.latitude;
  double longitude = LocationClass.longitude;

  //var googleOffices1;
  GoogleMapController? googleMapController;
  Completer<GoogleMapController> _completer = Completer(); //카메라 위치를 바꾸기 위한 변수
  Future<void> animateTo(double lat, double lng) async {
    final c = await _completer.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 10.0);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  } //카메라 위치를 바꾸기 위한 함수

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _completer.complete(controller);
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/map_marker/pin.png",
    ); //구글 맵 마커 변경 변수
    final googleOffices1 = await location_Marker.getGoogleOffices2("글램핑");
    setState(() {
      _markers.clear();
      for (final office in googleOffices1.offices1!) {
        final marker = Marker(
          icon: markerbitmap,
          onTap: () async {
            await _widgetBox.showBottomInfo(
                context: context,
                name: office.campName1.toString(),
                url: office.firstImageUrl1.toString(),
                address: office.address1.toString(),
                num: office.tel1.toString(),
                freeCon: office.freeCon1.toString(),
                campName: office.campName1.toString(),
                glamping: office.glamping1.toString(),
                address1: office.address1.toString(),
                caravanSite: office.caravSite1.toString(),
                mainIntro: office.mainIntro1.toString(),
                campId: office.campId1.toString(),
                autoSite: office.autoSiteCo1.toString(),
                freecon2: office.freeCon21.toString(),
                posblfclty: office.posblFcltyCl1.toString(),
                toilet: office.toilet1.toString(),
                shower: office.shower1.toString(),
                x: office.mapx1.toString(),
                y: office.mapy1.toString());
          },
          markerId: MarkerId((_count += 1).toString()),
          position: LatLng(double.parse(office.mapy1.toString()),
              double.parse(office.mapx1.toString())),
        );
        _markers[(_count += 1).toString()] = marker;
      }
    });
  }

  Set<Circle> circles = Set.from([
    Circle(
      fillColor: Colors.orange.shade100.withOpacity(0.5),
      strokeColor: Colors.blue.shade100.withOpacity(0.1),
      circleId: CircleId(DateTime.now().microsecondsSinceEpoch.toString()),
      center: LatLng(LocationClass.latitude, LocationClass.longitude),
      radius: 20000,
    )
  ]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("위도 : ${latitude}");
    print(longitude);
    _onMapCreated;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 140,
                child: latitude != null
                    ? GoogleMap(
                        // onCameraMove: ,
                        circles: circles,
                        //내 위치 주변으로 원 둘레 생성
                        myLocationEnabled: true,
                        // 내 위치 활성화
                        mapType: MapType.normal,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(latitude, longitude),
                          zoom: 7,
                        ),
                        markers: _markers.values.toSet(),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 35,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _locationCount = index;
                            print(index);
                          });
                          if (_locationCount == 0) {
                            //쿼리에 다시 재입력 해야함.
                            latitude = locations[0]["내위치"]![0];
                            longitude = locations[0]["내위치"]![1];
                            animateTo(latitude, longitude);
                          } else if (_locationCount == 1) {
                            longitude = locations[1]["가평"]![0];
                            latitude = locations[1]["가평"]![1];
                            animateTo(latitude, longitude);
                          } else if (index == 2) {
                            longitude = locations[2]["태안"]![0];
                            latitude = locations[2]["태안"]![1];
                            animateTo(latitude, longitude);
                          } else {
                            longitude = locations[3]["서귀포"]![0];
                            latitude = locations[3]["서귀포"]![1];
                            animateTo(latitude, longitude);
                          }
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: index == _locationCount
                                ? ColorBox.buttonColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            locations[index].keys.join(","),
                            style: TextStyle(
                                fontSize: 16,
                                color: index == _locationCount
                                    ? Colors.white
                                    : Colors.grey[800]),
                          )),
                        ),
                      );
                    },
                    itemCount: locations.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 10,
                      );
                    },
                  ),
                ),
              ),
              openPanel(title: "", content: "", dateTime: ""),
            ],
          ),
        )
      ],
    ));
  }

  Widget openPanel(
      {required String title,
      required String content,
      required String dateTime}) {
    return SlidingUpPanel(
      renderPanelSheet: true,
      panel: openLocationPanel(),
      backdropEnabled: true,
      minHeight: 90,
      maxHeight: 200,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
    );
  }

  Widget openLocationPanel() {
    return Column(
      children: [
        SizedBox(
          height: 35,
        ),
        Text(
          "어떤 캠핑을 찾고있나요?",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 35,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: Container(
                  width: 350,
                  height: 100,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              _bottomCount = index;
                            });
                            if(_bottomCount == 0){
                              latitude = 37.514575;
                              longitude = 127.0495556;
                              setState(() {
                                locationMarker("글램핑");
                                animateTo(latitude, longitude);
                              });
                            }else if(_bottomCount == 1){
                              latitude = 37.514575;
                              longitude = 127.0495556;
                              setState(() {
                                locationMarker("오토캠핑");
                                animateTo(latitude, longitude);
                              });
                            }else{
                              latitude = 37.514575;
                              longitude = 127.0495556;
                              setState(() {
                                animateTo(latitude, longitude);
                                locationMarker("카라반");
                              });
                            }
                          },
                          child: Container(
                            child: Text(campKind[index],style: TextStyle(color: Colors.grey[800]),),
                              padding: EdgeInsets.all(30.0),
                              margin: EdgeInsets.all(5.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ))),
                        );
                      },
                      separatorBuilder: (ctx, idx) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                      itemCount: campKind.length)),
            ),
          ],
        ),
      ],
    );
  }

  void locationMarker(String text) async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "lib/map_marker/pin.png",
    );
    _locationText = text;
    final googleOffices1 =
        await location_Marker.getGoogleOffices2(_locationText!);
    setState(() {
      _markers.clear();
      for (final office in googleOffices1.offices1!) {
        final marker = Marker(
          icon: markerbitmap,
          onTap: () {},
          markerId: MarkerId((_count.toString().hashCode).toString()),
          position: LatLng(double.parse(office.mapy1.toString()),
              double.parse(office.mapx1.toString())),
        );
        _markers[(_count += 1).toString()] = marker;
      }
    });
  }
}
