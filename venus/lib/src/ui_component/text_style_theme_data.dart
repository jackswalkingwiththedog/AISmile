import 'package:flutter/material.dart';

class TextStyleThemeData {
  final TextStyle header4;
  final TextStyle header5;
  final TextStyle header6;
  final TextStyle subtitle1;
  final TextStyle subtitle2;
  final TextStyle subtitle3;
  final TextStyle body1;
  final TextStyle body2;
  final TextStyle body3;
  final TextStyle caption1;
  final TextStyle caption2;
  final TextStyle caption3;
  final TextStyle caption4;
  final TextStyle button1;
  final TextStyle button2;
  final TextStyle linkbutton1;
  final TextStyle linkbutton2;

  TextStyleThemeData({
    required this.header4,
    required this.header5,
    required this.header6,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle3,
    required this.body1,
    required this.body2,
    required this.body3,
    required this.caption1,
    required this.caption2,
    required this.caption3,
    required this.caption4,
    required this.button1,
    required this.button2,
    required this.linkbutton1,
    required this.linkbutton2,
  });

  TextStyleThemeData copyWith({
    TextStyle? header4,
    TextStyle? header5,
    TextStyle? header6,
    TextStyle? subtitle1,
    TextStyle? subtitle2,
    TextStyle? subtitle3,
    TextStyle? body1,
    TextStyle? body2,
    TextStyle? body3,
    TextStyle? caption1,
    TextStyle? caption2,
    TextStyle? caption3,
    TextStyle? caption4,
    TextStyle? button1,
    TextStyle? button2,
    TextStyle? linkbutton1,
    TextStyle? linkbutton2,
  }) =>
      TextStyleThemeData(
        header4: header4 ?? this.header4,
        header5: header5 ?? this.header5,
        header6: header6 ?? this.header6,
        subtitle1: subtitle1 ?? this.subtitle1,
        subtitle2: subtitle2 ?? this.subtitle2,
        subtitle3: subtitle3 ?? this.subtitle3,
        body1: body1 ?? this.body1,
        body2: body2 ?? this.body2,
        body3: body3 ?? this.body3,
        caption1: caption1 ?? this.caption1,
        caption2: caption2 ?? this.caption2,
        caption3: caption3 ?? this.caption3,
        caption4: caption4 ?? this.caption4,
        button1: button1 ?? this.button1,
        button2: button2 ?? this.button2,
        linkbutton1: linkbutton1 ?? this.linkbutton1,
        linkbutton2: linkbutton2 ?? this.linkbutton2,
      );
}
