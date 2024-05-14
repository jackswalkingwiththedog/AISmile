import 'package:flutter/material.dart';

import 'app_colors.dart';

class ColorThemeData {
  final MaterialColor primarySwatch;

  final Color primaryColorDarker;
  final Color primaryColorDark;

  final Color primaryColor;
  final Color primaryColorLight;

  final Color primaryMonoDarkColor;
  final Color primaryMonoLightColor;

  final Color successIndicatorColor;
  final Color failureIndicatorColor;
  final Color infoIndicatorColor;
  final Color readyIndicatorColor;
  final Color highlightIndicatorColor;
  final Color muteIndicatorColor;

  final Color foreground90Color;
  final Color foreground60Color;
  final Color foreground50Color;
  final Color foreground40Color;
  final Color foreground30Color;
  final Color foreground15Color;
  final Color foreground5Color;
  final Color foregroundNegativeColor;

  Color get borderColor => foreground30Color;
  Color get disabledColor => foreground15Color;

  Color get transparent => AppColors.transparent;

  final Color backgroundColor;
  final Color appbarBackgroundColor;
  final Color windowBackgroundColor;
  final Color dividerColor;
  final Color textDividerColor;
  final Color iconBackgroundColor;

  final Color infoIndicatorBackgroundColor;

  final Color brandTextColor;
  final Color informationTextColor;
  final Color successTextColor;
  final Color waringTextColor;
  final Color errorTextColor;
  final Color defaultTextColor;
  final Color secondaryTextColor;
  final Color whiteTextColor;
  final Color actionTextColor;
  final Color snackBarBackgroundColor;
  final Color dateRangeHighlightColor;
  final Color dateRangeStartColor;
  final Color fontError500;

  ColorThemeData({
    required this.primarySwatch,
    required this.primaryColorDarker,
    required this.primaryColorDark,
    required this.primaryColor,
    required this.primaryColorLight,
    required this.primaryMonoDarkColor,
    required this.primaryMonoLightColor,
    required this.successIndicatorColor,
    required this.failureIndicatorColor,
    required this.infoIndicatorColor,
    required this.readyIndicatorColor,
    required this.highlightIndicatorColor,
    required this.muteIndicatorColor,
    required this.foreground90Color,
    required this.foreground60Color,
    required this.foreground50Color,
    required this.foreground40Color,
    required this.foreground30Color,
    required this.foreground15Color,
    required this.foreground5Color,
    required this.foregroundNegativeColor,
    required this.backgroundColor,
    required this.windowBackgroundColor,
    required this.appbarBackgroundColor,
    required this.dividerColor,
    required this.textDividerColor,
    required this.iconBackgroundColor,
    required this.infoIndicatorBackgroundColor,
    required this.brandTextColor,
    required this.informationTextColor,
    required this.successTextColor,
    required this.waringTextColor,
    required this.errorTextColor,
    required this.defaultTextColor,
    required this.secondaryTextColor,
    required this.whiteTextColor,
    required this.actionTextColor,
    required this.snackBarBackgroundColor,
    required this.dateRangeHighlightColor,
    required this.dateRangeStartColor,
    required this.fontError500,
  });

  ColorThemeData copyWith({
    MaterialColor? primarySwatch,
    Color? primaryColorDarker,
    Color? primaryColorDark,
    Color? primaryColor,
    Color? primaryColorLight,
    Color? primaryMonoDarkColor,
    Color? primaryMonoLightColor,
    Color? successIndicatorColor,
    Color? failureIndicatorColor,
    Color? infoIndicatorColor,
    Color? readyIndicatorColor,
    Color? highlightIndicatorColor,
    Color? muteIndicatorColor,
    Color? foreground90Color,
    Color? foreground60Color,
    Color? foreground50Color,
    Color? foreground40Color,
    Color? foreground30Color,
    Color? foreground15Color,
    Color? foreground5Color,
    Color? foregroundNegativeColor,
    Color? backgroundColor,
    Color? appbarBackgroundColor,
    Color? windowBackgroundColor,
    Color? dividerColor,
    Color? textDividerColor,
    Color? iconBackgroundColor,
    Color? infoIndicatorBackgroundColor,
    Color? brandTextColor,
    Color? informationTextColor,
    Color? successTextColor,
    Color? waringTextColor,
    Color? errorTextColor,
    Color? defaultTextColor,
    Color? secondaryTextColor,
    Color? whiteTextColor,
    Color? actionTextColor,
    Color? snackBarBackgroundColor,
    Color? dateRangeHighlightColor,
    Color? dateRangeStartColor,
    Color? fontError500,
  }) =>
      ColorThemeData(
        primarySwatch: primarySwatch ?? this.primarySwatch,
        primaryColorDarker: primaryColorDarker ?? this.primaryColorDarker,
        primaryColorDark: primaryColorDark ?? this.primaryColorDark,
        primaryColor: primaryColor ?? this.primaryColor,
        primaryColorLight: primaryColorLight ?? this.primaryColorLight,
        primaryMonoDarkColor: primaryMonoDarkColor ?? this.primaryMonoDarkColor,
        primaryMonoLightColor: primaryMonoLightColor ?? this.primaryMonoLightColor,
        successIndicatorColor: successIndicatorColor ?? this.successIndicatorColor,
        failureIndicatorColor: failureIndicatorColor ?? this.failureIndicatorColor,
        infoIndicatorColor: infoIndicatorColor ?? this.infoIndicatorColor,
        readyIndicatorColor: readyIndicatorColor ?? this.readyIndicatorColor,
        highlightIndicatorColor: highlightIndicatorColor ?? this.highlightIndicatorColor,
        muteIndicatorColor: muteIndicatorColor ?? this.muteIndicatorColor,
        foreground90Color: foreground90Color ?? this.foreground90Color,
        foreground60Color: foreground60Color ?? this.foreground60Color,
        foreground50Color: foreground50Color ?? this.foreground50Color,
        foreground40Color: foreground40Color ?? this.foreground40Color,
        foreground30Color: foreground30Color ?? this.foreground30Color,
        foreground15Color: foreground15Color ?? this.foreground15Color,
        foreground5Color: foreground5Color ?? this.foreground5Color,
        foregroundNegativeColor: foregroundNegativeColor ?? this.foregroundNegativeColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        appbarBackgroundColor: appbarBackgroundColor ?? this.appbarBackgroundColor,
        windowBackgroundColor: windowBackgroundColor ?? this.windowBackgroundColor,
        dividerColor: dividerColor ?? this.dividerColor,
        textDividerColor: textDividerColor ?? this.textDividerColor,
        iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
        infoIndicatorBackgroundColor: infoIndicatorBackgroundColor ?? this.infoIndicatorBackgroundColor,
        brandTextColor: brandTextColor ?? this.brandTextColor,
        informationTextColor: informationTextColor ?? this.informationTextColor,
        successTextColor: successTextColor ?? this.successTextColor,
        waringTextColor: waringTextColor ?? this.waringTextColor,
        errorTextColor: errorTextColor ?? this.errorTextColor,
        defaultTextColor: defaultTextColor ?? this.defaultTextColor,
        secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
        whiteTextColor: whiteTextColor ?? this.whiteTextColor,
        actionTextColor: actionTextColor ?? this.actionTextColor,
        snackBarBackgroundColor: snackBarBackgroundColor ?? this.snackBarBackgroundColor,
        dateRangeHighlightColor: dateRangeHighlightColor ?? this.dateRangeHighlightColor,
        dateRangeStartColor: dateRangeStartColor ?? this.dateRangeStartColor,
        fontError500: fontError500 ?? this.fontError500,
      );
}
