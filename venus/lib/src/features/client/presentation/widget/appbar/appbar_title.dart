import 'package:flutter/material.dart';
import 'package:venus/src/ui_component/custom_text.dart';
import 'package:venus/src/ui_component/theme.dart';
import 'package:venus/src/utils/constants/colors.dart';

class AppBarTitle extends StatelessWidget {
  final bool hideLeading;
  final String title;
  final Color? backgroundColor;
  final Widget? searchBar;

  const AppBarTitle({
    Key? key,
    this.searchBar,
    required this.hideLeading,
    required this.title,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searchBar != null
        //ignore: no-direct-padding
        ? Padding(
          padding: EdgeInsets.only(left: hideLeading ? 8 : 0),
          child: searchBar,
        )
        : backgroundColor == null || backgroundColor == ColorTheme.of(context).appbarBackgroundColor
            ? CustomText.subtitle1(
                title,
                color: TColors.white,
                overflow: TextOverflow.ellipsis,
              )
            : CustomText.subtitle1(
                title,
                color: TColors.white,
                overflow: TextOverflow.ellipsis,
              );
  }
}
