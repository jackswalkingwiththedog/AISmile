import 'package:flutter/widgets.dart';
import 'package:venus/src/ui_component/theme.dart';


class BottomDivider extends StatelessWidget {
  final Color? dividerColor;
  const BottomDivider({Key? key, this.dividerColor}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: dividerColor ?? ColorTheme.of(context).foreground5Color,
        height: bottomDividerHeight,
      );
}

const double bottomDividerHeight = 1;
