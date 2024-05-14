import 'package:flutter/material.dart';
import 'package:venus/src/ui_component/text_style_theme.dart';
import 'package:venus/src/ui_component/theme.dart';


class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? Function(BuildContext) textStyle;
  final Color? color;
  final TextAlign? textAlign;
  final bool? softwrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final Key? keyText;

  const CustomText._(
    this.text,
    this.textStyle, {
    this.color,
    this.textAlign,
    this.softwrap,
    this.overflow,
    this.maxLines,
    this.keyText,
    Key? key,
  }) : super(key: key);

  /// new values for facelift new design system implementation
  // Headline - H4 30/44 and other H4 was replaced by header4
  CustomText.header4(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).header4.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Headline - H5 24/36 and other H5 was replaced by header5
  CustomText.header5(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).header5.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Headline - H6 18/26 and other H6 was replaced by header6
  CustomText.header6(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).header6.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Subtitle - S1M 18/24 and other S1 was replaced by subtitle1
  CustomText.subtitle1(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).subtitle1.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Subtitle - S2M 14/20 was replaced by subtitle2
  CustomText.subtitle2(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).subtitle2.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Subtitle - S2MU 14/20 was/will be removed/replaced by subtitle 3
  CustomText.subtitle3(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).subtitle3.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Body - B2M 14/20 was replaced by body1
  CustomText.body1(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).body1.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Body - B2R 14/20 was replaced by body2
  CustomText.body2(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).body2.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  CustomText.body2LineThrough(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => color == null
              ? TextStyleTheme.of(c).body2.copyWith(decoration: TextDecoration.lineThrough)
              : TextStyleTheme.of(c).body2.copyWith(color: color, decoration: TextDecoration.lineThrough),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  CustomText.body3(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).body3.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  CustomText.body3LineThrough(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => color == null
              ? TextStyleTheme.of(c).body3.copyWith(decoration: TextDecoration.lineThrough)
              : TextStyleTheme.of(c).body3.copyWith(color: color, decoration: TextDecoration.lineThrough),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Button - BMS 12/16 was replaced by caption1
  CustomText.caption1(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).caption1.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Caption - CR 12/18 was replaced by caption2
  CustomText.caption2(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).caption2.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  CustomText.caption2LineThrough(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => color == null
              ? TextStyleTheme.of(c).caption2.copyWith(decoration: TextDecoration.lineThrough)
              : TextStyleTheme.of(c).caption2.copyWith(color: color, decoration: TextDecoration.lineThrough),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  CustomText.caption3(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).caption3.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  CustomText.caption3LineThrough(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => color == null
              ? TextStyleTheme.of(c).caption3.copyWith(decoration: TextDecoration.lineThrough)
              : TextStyleTheme.of(c).caption3.copyWith(color: color, decoration: TextDecoration.lineThrough),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  CustomText.caption4(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).caption4.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Button - B2M 14/20 was replaced by button1
  CustomText.button1(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).button1.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  // Button - BM 14/16 was replaced by button2
  CustomText.button2(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).button2.copyWith(color: color ?? ColorTheme.of(c).defaultTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  CustomText.linkbutton1(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).linkbutton1.copyWith(color: color ?? ColorTheme.of(c).informationTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  CustomText.linkbutton2(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool? softwrap,
    TextOverflow? overflow,
    int? maxLines,
    Key? key,
    Key? keyText,
  }) : this._(
          text,
          (c) => TextStyleTheme.of(c).linkbutton2.copyWith(color: color ?? ColorTheme.of(c).informationTextColor),
          textAlign: textAlign,
          softwrap: softwrap,
          overflow: overflow,
          maxLines: maxLines,
          key: key,
          keyText: keyText,
        );

  @override
  // ignore: koyal-text
  Widget build(BuildContext context) => Text(
        key: keyText,
        text,
        textAlign: textAlign,
        softWrap: softwrap,
        overflow: overflow,
        maxLines: maxLines,
        style: textStyle(context),
      );
}
