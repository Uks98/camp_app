 import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
 import 'package:http/http.dart' as http;
class LocationClass{
   static var longitude;
   static var latitude;

   void getLocation(BuildContext context) async {
     LocationPermission per = await Geolocator.checkPermission();
     if (per == LocationPermission.denied ||
         per == LocationPermission.deniedForever) {
       toastMessage(context,"위치를 허용해주세요");
       LocationPermission per1 = await Geolocator.requestPermission();
     } else {
       Position currentLoc = await Geolocator.getCurrentPosition(
           desiredAccuracy: LocationAccuracy.best);
       toastMessage(context, "정보를 불러왔습니다.",);
       longitude = currentLoc.longitude;
       latitude = currentLoc.latitude;
       print(longitude);
       print(latitude);
     }
   }
   void toastMessage(BuildContext context,String text){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text),backgroundColor: Colors.white,));
   }
 }
