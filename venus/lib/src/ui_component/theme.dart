import 'package:flutter/material.dart';

import 'color_theme_data.dart';
import 'default_color_theme_data.dart';

final ColorThemeData _kFallbackTheme = getDefaultColorThemeData();

class ColorTheme extends InheritedWidget {
  final ColorThemeData data;

  const ColorTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ColorTheme oldWidget) {
    return oldWidget.data != data;
  }

  static ColorThemeData of(BuildContext context) {
    final colorTheme = context.dependOnInheritedWidgetOfExactType<ColorTheme>();

    return colorTheme?.data ?? _kFallbackTheme;
  }
}
