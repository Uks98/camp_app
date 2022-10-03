
import 'package:flutter/material.dart';

import '../color/color.dart';

class WidgetBox{

  Widget loginContainer(VoidCallback voidCallback,String title,String imagePath){
    return Container(
      width: 380,
      height: 50,
      child: ElevatedButton(
        onPressed: voidCallback,
        style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(imagePath,fit: BoxFit.contain,width: 35,height: 35,),
            Center(
              child: Text(title,style: TextStyle(color: Colors.grey[800]),),
            ),
            Opacity(
              opacity: 0.0,
              child: Image.asset(
                "lib/asset/google_lo.png",),
            )
          ],
        ),
      ),
    );
  }
}