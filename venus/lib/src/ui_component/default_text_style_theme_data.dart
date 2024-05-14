import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'text_style_theme_data.dart';

String _defaultFontFamily = GoogleFonts.lexend().fontFamily.toString();
String _hindiFontFamily = GoogleFonts.poppins().fontFamily.toString();
String _notoSansFontFamily = GoogleFonts.notoSans().fontFamily.toString();

List<String> _fontFamilyFallback = <String>[
  _notoSansFontFamily,
];

String getFontFamily(String? languageCode) {
  if (languageCode == 'hi') {
    return _hindiFontFamily;
  }
  return _defaultFontFamily;
}

TextStyleThemeData getDefaultTextStyleThemeData(BuildContext context, {String? selectedLocale}) {
  return TextStyleThemeData(
    header4: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 32,
      height: 1.5, // 32 * 1.5 = 48 line height
      fontWeight: FontWeight.w600,
      letterSpacing: 0.25,
    ),
    header5: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 24,
      height: 1.5, // 24 * 1.5 = 36 line height
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
    ),
    header6: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 20,
      height: 1.4, // 20 * 1.4 = 28 line height
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),

    // Subtitle
    subtitle1: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 16,
      height: 1.5, // 16 * 1.5 = 24 line height
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    ),
    subtitle2: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 14,
      height: 1.43, // 14 * 1.43 = 20 line height
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    subtitle3: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 14,
      height: 1.43, // 14 * 1.43 = 20 line height
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),

    // Body
    body1: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 14,
      height: 1.43, // 14 * 1.43 = 20 line height
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    body2: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 14,
      height: 1.43, // 14 * 1.43 = 20 line height
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    body3: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 14,
      height: 1.43, // 14 * 1.43 = 20 line height
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),

    // Caption
    caption1: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 12,
      height: 1.34, // 12 * 1.34 = 16 line height
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    caption2: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 12,
      height: 1.34, // 12 * 1.34 = 16 line height
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    caption3: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 12,
      height: 1.34, // 12 * 1.34 = 16 line height
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    caption4: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 10,
      height: 1.4, // 10 * 1.4 = 14 line height
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),

    /// line height 1.0 is used for buttons to avoid unwanted topPadding
    // Button
    button1: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 14,
      height: 1.72, // 14 * 1.72 = 24 line height
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    button2: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 12,
      height: 1.7, // 12 * 1.7 = 20 line height
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    linkbutton1: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 14,
      height: 1.43, // 14 * 1.43 = 20 line height
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    linkbutton2: TextStyle(
      fontFamily: getFontFamily(selectedLocale),
      fontFamilyFallback: _fontFamilyFallback,
      fontSize: 12,
      height: 1.34, // 12 * 1.34 = 16 line height
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
  );
}