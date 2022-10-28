import 'package:camper/data/location_camp_data.dart'as location_Marker;
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
  final Map<String, Marker> _markers = {};
  String get keyword => this.keyword;
  List<LocationCampData> locationData = []; // Futuer list<LocationMapData>에서 반환한 리스트 받아오기

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices1 = await  location_Marker.getGoogleOffices2();
    setState(() {
      _markers.clear();
      for (final office in googleOffices1.offices1!) {
        print("맵 정보 ${office.mapx1}");
        final marker = Marker(
          markerId: MarkerId((_count +=1).toString()),
          position: LatLng(double.parse(office.mapy1.toString()), double.parse(office.mapx1.toString())),
        );
        _markers[(_count +=1).toString()] = marker;
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("위도 : ${LocationClass.latitude}");
    print(LocationClass.longitude);
    getLocationCampData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
              width: 400,
              height: 400,
              child: GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(36.0345423,128.6142847),
                  zoom: 14,
                ),
                markers: _markers.values.toSet(),
              ),
            )
    );
  }
  void getLocationCampData() async {
    locationData = (await _locationCampData.getLocationCampList(
        context: context))!;
    setState(() {});
  }
}
