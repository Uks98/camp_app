import 'package:camper/widget/widget_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DecorationWidgetBox {
  Widget listMargin() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Divider(
          thickness: 1.3,
          indent: 10,
          endIndent: 10,
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}
