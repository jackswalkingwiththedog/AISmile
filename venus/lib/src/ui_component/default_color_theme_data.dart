// ignore_for_file: no-direct-colors

import 'package:flutter/material.dart';

import 'color_theme_data.dart';
import 'app_colors.dart';

ColorThemeData getDefaultColorThemeData() => ColorThemeData(
      primarySwatch: getDefaultPrimarySwatch(),
      primaryColorDarker: AppColors.darkRed,
      primaryColorDark: AppColors.darkLightRed,
      primaryColor: AppColors.primary500,
      primaryColorLight: AppColors.lightRed,
      primaryMonoDarkColor: AppColors.darkGrey,
      primaryMonoLightColor: AppColors.mediumGrey,
      successIndicatorColor: AppColors.semanticGreen500,
      failureIndicatorColor: AppColors.semanticRed500,
      infoIndicatorColor: AppColors.secondary500,
      readyIndicatorColor: AppColors.orangeIndicator,
      highlightIndicatorColor: AppColors.yellowIndicator,
      muteIndicatorColor: AppColors.semanticRed50,
      foreground90Color: AppColors.supplementary900,
      foreground60Color: AppColors.supplementary500,
      foreground50Color: AppColors.supplementary400,
      foreground40Color: AppColors.supplementary300,
      foreground30Color: AppColors.supplementary200,
      foreground15Color: AppColors.supplementary100,
      foreground5Color: AppColors.supplementary50,
      foregroundNegativeColor: AppColors.supplementary0,
      backgroundColor: AppColors.supplementary0,
      windowBackgroundColor: AppColors.windowBackground,
      appbarBackgroundColor: AppColors.supplementary0,
      dividerColor: AppColors.supplementary50,
      textDividerColor: AppColors.supplementary25,
      iconBackgroundColor: AppColors.blueGray,
      infoIndicatorBackgroundColor: AppColors.secondary50,
      brandTextColor: AppColors.primary500,
      informationTextColor: AppColors.secondary600,
      successTextColor: AppColors.semanticGreen900,
      waringTextColor: AppColors.semanticOrange900,
      errorTextColor: AppColors.semanticRed700,
      defaultTextColor: AppColors.supplementary900,
      secondaryTextColor: AppColors.supplementary500,
      whiteTextColor: AppColors.supplementary0,
      actionTextColor: AppColors.primary300,
      snackBarBackgroundColor: AppColors.supplementary700,
      dateRangeHighlightColor: AppColors.primary50,
      dateRangeStartColor: AppColors.primary200,
      fontError500: AppColors.primary900,
    );

MaterialColor getDefaultPrimarySwatch() => const MaterialColor(
      0xFFE11931,
      <int, Color>{
        50: Color.fromRGBO(_r, _g, _b, 0.1),
        100: Color.fromRGBO(_r, _g, _b, 0.2),
        200: Color.fromRGBO(_r, _g, _b, 0.3),
        300: Color.fromRGBO(_r, _g, _b, 0.4),
        400: Color.fromRGBO(_r, _g, _b, 0.5),
        500: Color.fromRGBO(_r, _g, _b, 0.6),
        600: Color.fromRGBO(_r, _g, _b, 0.7),
        700: Color.fromRGBO(_r, _g, _b, 0.8),
        800: Color.fromRGBO(_r, _g, _b, 0.9),
        900: Color.fromRGBO(_r, _g, _b, 1),
      },
    );

const _r = 225;
const _g = 25;
const _b = 49;
