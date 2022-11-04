import 'package:flutter/material.dart';

class TextFieldBox{
  static const double _radius = 5;
  Widget contentField(TextEditingController textEditingController,int maxLine,int minLine){
    return TextField(
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.white,
      controller: textEditingController,
      maxLines: maxLine,
      minLines: minLine,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(_radius),
          ),
          fillColor: Colors.black,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.circular(_radius),
          ),
          focusColor: Colors.grey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_radius),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
          hintText: "게시글을 입력해주세요."),
    );
  }
}