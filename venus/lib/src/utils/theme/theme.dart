import 'package:flutter/material.dart';
import 'package:venus/src/utils/constants/colors.dart';
import 'package:venus/src/utils/theme/custom_themes/appbar_theme.dart';
import 'package:venus/src/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:venus/src/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:venus/src/utils/theme/custom_themes/chip_theme.dart';
import 'package:venus/src/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:venus/src/utils/theme/custom_themes/outline_button_theme.dart';
import 'package:venus/src/utils/theme/custom_themes/text_button_theme.dart';
import 'package:venus/src/utils/theme/custom_themes/text_field_theme.dart';
import 'package:venus/src/utils/theme/custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlineButtonTheme.lightOutlineButtonTheme,
    textButtonTheme: TTextButtonTheme.lightTextButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData dartTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    primaryColor: TColors.primary,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlineButtonTheme.darkOutlineButtonTheme,
    textButtonTheme: TTextButtonTheme.darkTextButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}