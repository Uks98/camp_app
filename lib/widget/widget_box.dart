import 'package:flutter/material.dart';

import '../color/color.dart';

class WidgetBox {
  Widget loginContainer(
      VoidCallback voidCallback, String title, String imagePath) {
    return Container(
      color: Colors.white,
      width: 380,
      height: 50,
      child: ElevatedButton(
        onPressed: voidCallback,
        style: ElevatedButton.styleFrom(elevation: 5, primary: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
              width: 35,
              height: 35,
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(color: Colors.grey[800]),
              ),
            ),
            Opacity(
              opacity: 0.0,
              child: Image.asset(
                "lib/asset/google_lo.png",
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget campingListWidget(
      String imaUrl, String name, String location, String x) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                    image: NetworkImage(imaUrl), fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  location,
                  style: TextStyle(fontSize: 14, color: ColorBox.textColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(x,
                    style: TextStyle(fontSize: 14, color: ColorBox.textColor)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
