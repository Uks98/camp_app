import 'package:camper/data/location_camp_data.dart';
import 'package:camper/page/detail_page.dart';
import 'package:flutter/material.dart';

import '../color/color.dart';
import '../service/Item.dart';

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
                      style:
                          TextStyle(fontSize: 13, color: ColorBox.textColor)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget searchCampBox(String image, String name, String location, String intro,
      VoidCallback callback) {
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
            margin: EdgeInsets.only(left: 30, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  location,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 5),
                Text(
                  intro,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
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

  Future<void> showBottomInfo({
    required BuildContext context,
    required String name,
    required String url,
    required String address,
    required String num,
    required String campId,
    required String campName,
    required String address1,
    required String freeCon,
    required String mainIntro,
    required String autoSite,
    required String glamping,
    required String caravanSite,
    required String toilet,
    required String shower,
    required String freecon2,
    required String posblfclty,
    required String x,
    required String y,
  }) async {
    return await showModalBottomSheet<void>(
        useRootNavigator: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              print(x.toString());
              print(y.toString());
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPage(
                    markData: LocationCampData(
                        campId1: campId.toString(),
                        campName1: campName.toString(),
                        address1: address.toString(),
                        freeCon1: freeCon.toString(),
                        mainIntro1: mainIntro.toString(),
                        autoSiteCo1: autoSite.toString(),
                        glamping1: glamping.toString(),
                        caravSite1: caravanSite.toString(),
                        toilet1: toilet.toString(),
                        shower1: shower.toString(),
                        mapx1: x,
                        mapy1: y
                    )),
              ));
            },
            child: Container(
              height: 350,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      '캠핑장 안내',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ClipRRect(
                      child: url == ""
                          ? Image.network(
                              "http://sanpo.pfmall.co.kr/img/no-image.png",
                              width: 200,
                              height: 200,
                            )
                          : Image.network(
                              url,
                              width: 350,
                              height: 210,
                              fit: BoxFit.cover,
                            ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 27),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(address),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
