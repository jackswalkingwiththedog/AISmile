import 'package:flutter/material.dart';

import 'default_text_style_theme_data.dart';
import 'text_style_theme_data.dart';

class TextStyleTheme extends InheritedWidget {
  final TextStyleThemeData data;

  const TextStyleTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(TextStyleTheme oldWidget) {
    return oldWidget.data != data;
  }

  static TextStyleThemeData of(BuildContext context, {String? selectedLocale}) {
    final textTheme = context.dependOnInheritedWidgetOfExactType<TextStyleTheme>();

    return textTheme?.data ??
        getDefaultTextStyleThemeData(
          context,
          selectedLocale: selectedLocale,
        );
  }
}
