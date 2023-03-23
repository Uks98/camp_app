import 'dart:async';
import 'dart:convert';

import 'package:camper/data/camp_data.dart';
import 'package:camper/data/location_camp_data.dart';
import 'package:camper/widget/detail_witget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../service/Item.dart';
class DetailPage extends StatefulWidget {
  DetailPage({Key? key,this.campData,this.markData}) : super(key: key);
  CampData? campData;
  LocationCampData? markData;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var ids;
  CampItem _campItem = CampItem();
  DetailWidget _detailWidget = DetailWidget();
  DetailWidget get detailWidget{
    return _detailWidget;
  }
  CampData? get campDataG{
    return widget.campData;
  }

  LocationCampData? get markDataG{
    return widget.markData;
  }

  List? data = [];
  String? imageUrl;
  //구글맵에 사용되는 변수
  Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> _controller2 = Completer();
  Map<MarkerId, Marker> markers = {};
  Map<MarkerId, Marker> markers2 = {};
  CameraPosition? _GoogleMapCamera; //전체 지도의 마커
  CameraPosition? _GoogleMapCamera2; //상세 페이지의 마커
  TextEditingController? _reviewTextController = TextEditingController();
  Marker? marker;
  Marker? marker2;
  void getImage(){
    if(markDataG == null){
      getImageData(campDataG!.campId.toString());
    }else{
      getImageData(markDataG!.campId1.toString());
    }
  }
  void getGoogle(){
    if(markDataG == null) {
      _GoogleMapCamera = CameraPosition(
        target: LatLng(double.parse(campDataG!.mapy.toString()),
            double.parse(campDataG!.mapx.toString())),
        zoom: 16,
      );
      MarkerId markerId = MarkerId(campDataG.hashCode.toString());
      marker = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(10.0),
          position: LatLng(double.parse(campDataG!.mapy.toString()),
              double.parse(campDataG!.mapx.toString())),
          flat: true,
          markerId: markerId);
      markers[markerId] = marker!;
    }
    else{
      _GoogleMapCamera2 = CameraPosition(
        target: LatLng(double.parse(markDataG!.mapy1.toString()),
            double.parse(markDataG!.mapx1.toString())),
        zoom: 16,
      );
      MarkerId markerId2 = MarkerId(markDataG.hashCode.toString());
      marker2 = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(10.0),
          position: LatLng(double.parse(markDataG!.mapy1.toString()),
              double.parse(markDataG!.mapx1.toString())),
          flat: true,
          markerId: markerId2);
      markers2[markerId2] = marker2!;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
    getGoogle();
  }
  @override
  Widget build(BuildContext context) {
    ids = ModalRoute.of(context)!.settings.arguments.toString();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: widget.markData != null ? detailWidget.drawCampDetail(
             campId: markDataG!.campId1.toString(), campName: markDataG!.campName1.toString(), address: markDataG!.address1.toString(), freeCon: markDataG!.freeCon1.toString(), mainIntro: markDataG!.mainIntro1.toString(),
             autoSite: markDataG!.autoSiteCo1.toString(), glamping: markDataG!.glamping1.toString(), caravanSite: markDataG!.caravSite1.toString(), ids: ids, data: data!,
             campG: CampItem(), context: context,toilet: markDataG!.toilet1.toString(),shower: markDataG!.shower1.toString(),googleMap: getGoogleMap2(),x: campDataG!.mapx.toString(),y: campDataG!.mapy.toString()):

              detailWidget.drawCampDetail(
              campId: campDataG!.campId.toString(), campName: campDataG!.campName.toString(), address: campDataG!.address.toString(), freeCon: campDataG!.freeCon.toString(), mainIntro: campDataG!.mainIntro.toString(),
              autoSite: campDataG!.autoSiteCo.toString(), glamping: campDataG!.glamping.toString(), caravanSite: campDataG!.caravSite.toString(), ids: ids, data: data!,
              campG: CampItem(), context: context,toilet: campDataG!.toilet.toString(),shower: campDataG!.shower.toString(),googleMap: getGoogleMap(),x: campDataG!.mapx.toString(),y: campDataG!.mapy.toString())
        ),
      ),
    );
  }

  Future<String> getImageData(String id) async {
    var url = "https://apis.data.go.kr/B551011/GoCamping/imageList?serviceKey=iwOI%2BU0JCUIMem0fddRQ9Y4Fj2E254wSmoXLGM3hVwqHiS8h12%2FqNozM62Kb5D4ihpeW4KWouAt%2B9djISlDJzw%3D%3D&numOfRows=10&pageNo=1&MobileOS=AND&MobileApp=AppTest&_type=json&contentId=$id";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        var dartConvertedToJson = json.decode(response.body);
        List result = dartConvertedToJson["response"]["body"]["items"]["item"];
        print(result);
        data?.addAll(result);
      });
      return response.body;
    } else {
      return "";
    }
  }
  Widget getGoogleMap() {
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width - 50,
      child: GoogleMap(
          scrollGesturesEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _GoogleMapCamera!,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(markers.values)),
    );
  }
  Widget getGoogleMap2() {
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width - 50,
      child: GoogleMap(
          scrollGesturesEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _GoogleMapCamera2!,
          onMapCreated: (GoogleMapController controller) {
            _controller2.complete(controller);
          },
          markers: Set<Marker>.of(markers2.values)),
    );
  }
}
