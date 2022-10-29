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
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(imaUrl), fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 250,
              child: Column(
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
                    location.toString(),
                    style: TextStyle(fontSize: 13, color: ColorBox.textColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(x,
                      style: TextStyle(fontSize: 13, color: ColorBox.textColor)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget searchCampBox(String image,String name, String location,String intro,VoidCallback callback){
    return GestureDetector(
      onTap: callback,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.fill),
              ),
            ),
          ),
          Container(
            width: 350,
            margin: EdgeInsets.only(left: 30,top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(name,style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
                SizedBox(height: 10),
                Text(location,style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w500, fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                ),
                SizedBox(height: 5),
                Text(intro,style: TextStyle(color: Colors.grey[800],fontWeight: FontWeight.w500, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  PersistentBottomSheetController<void> showBottomInfo(BuildContext context,String name){
    return  Scaffold.of(context).showBottomSheet<void>(
            (BuildContext context) {
          return Container(
            height: 100,
            color: Colors.amber,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                   Text(name),
                  ElevatedButton(
                    child: const Text('Close BottomSheet'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}


