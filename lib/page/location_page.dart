import 'package:camper/color/color.dart';
import 'package:camper/data/location_camp_data.dart' as location_Marker;
import 'package:camper/widget/widget_box.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/location_camp_data.dart';
import '../service/location.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  int _count = 0;
  LocationClass locationClass = LocationClass();
  WidgetBox _widgetBox = WidgetBox();
  final Map<String, Marker> _markers = {};
  String get keyword => this.keyword;
  List<LocationCampData> locationData = []; // Futuer list<LocationMapData>에서 반환한 리스트 받아오기
  Future<void> _onMapCreated(GoogleMapController controller) async {

    final googleOffices1 = await location_Marker.getGoogleOffices2();
    setState(() {
      _markers.clear();
      for (final office in googleOffices1.offices1!) {
        final marker = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(10.0),
          onTap: (){
            _widgetBox.showBottomInfo(context,office.address1.toString());
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
    print("위도 : ${LocationClass.latitude}");
    print(LocationClass.longitude);
    _onMapCreated;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-100,
              child: GoogleMap(
                circles: circles,
                //내 위치 주변으로 원 둘레 생성
                myLocationEnabled: true,
                // 내 위치 활성화
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(LocationClass.latitude, LocationClass.longitude),
                  zoom: 10,
                ),
                markers: _markers.values.toSet(),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
