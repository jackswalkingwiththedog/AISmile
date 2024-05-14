import 'package:flutter/material.dart';


class CustomPadding extends StatelessWidget {

  static const paddingXSmall = 4.0;
  static const paddingSmall = 8.0;
  static const paddingNormal = 16.0;
  static const paddingLarge = 24.0;

  final Widget child;

  /// False if not apply left padding
  final bool left;

  /// False if not apply right padding
  final bool right;

  /// False if not apply top padding
  final bool top;

  /// False if not apply bottom padding
  final bool bottom;

  /// The offset is used for all edges.
  final double padding;

  const CustomPadding._(
    this.child, {
    required this.padding,
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
    Key? key,
  }) : super(key: key);

  /// X-Small = 4px
  const CustomPadding.xSmall({
    required Widget child,
    Key? key,
    bool left = true,
    bool right = true,
    bool top = true,
    bool bottom = true,
  }) : this._(child, padding: paddingXSmall, left: left, right: right, bottom: bottom, top: top, key: key);

  const CustomPadding.xSmallHorizontal({required Widget child, Key? key})
      : this._(child, padding: paddingXSmall, left: true, right: true, bottom: false, top: false, key: key);

  const CustomPadding.xSmallVertical({required Widget child, Key? key})
      : this._(child, padding: paddingXSmall, left: false, right: false, bottom: true, top: true, key: key);

  /// Small = 8px
  const CustomPadding.small({
    required Widget child,
    Key? key,
    bool left = true,
    bool right = true,
    bool top = true,
    bool bottom = true,
  }) : this._(child, padding: paddingSmall, left: left, right: right, bottom: bottom, top: top, key: key);

  const CustomPadding.smallHorizontal({required Widget child, Key? key})
      : this._(child, padding: paddingSmall, left: true, right: true, bottom: false, top: false, key: key);

  const CustomPadding.smallVertical({required Widget child, Key? key})
      : this._(child, padding: paddingSmall, left: false, right: false, bottom: true, top: true, key: key);

  /// Regular / Normal = 16px
  const CustomPadding.normalAll({
    required Widget child,
    Key? key,
    bool left = true,
    bool right = true,
    bool top = true,
    bool bottom = true,
  }) : this._(child, padding: paddingNormal, left: left, right: right, bottom: bottom, top: top, key: key);

  const CustomPadding.normalHorizontal({required Widget child, Key? key})
      : this._(child, padding: paddingNormal, left: true, right: true, bottom: false, top: false, key: key);

  const CustomPadding.normalVertical({required Widget child, Key? key})
      : this._(child, padding: paddingNormal, left: false, right: false, bottom: true, top: true, key: key);

  /// Large = 24px
  const CustomPadding.large({
    required Widget child,
    Key? key,
    bool left = true,
    bool right = true,
    bool top = true,
    bool bottom = true,
  }) : this._(child, padding: paddingLarge, left: left, right: right, bottom: bottom, top: top, key: key);

  const CustomPadding.largeHorizontal({required Widget child, Key? key})
      : this._(child, padding: paddingLarge, left: true, right: true, bottom: false, top: false, key: key);

  const CustomPadding.largeVertical({required Widget child, Key? key})
      : this._(child, padding: paddingLarge, left: false, right: false, bottom: true, top: true, key: key);

  @override
  Widget build(BuildContext context) {
    //ignore: no-direct-padding
    return Padding(
      padding: EdgeInsets.fromLTRB(left ? padding : 0, top ? padding : 0, right ? padding : 0, bottom ? padding : 0),
      child: child,
    );
  }
}
