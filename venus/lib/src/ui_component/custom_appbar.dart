import 'package:flutter/material.dart';
import 'package:venus/src/features/client/presentation/widget/appbar/appbar_title.dart';
import 'package:venus/src/ui_component/menu_item.dart';
import 'package:venus/src/ui_component/padding.dart';
import 'package:venus/src/ui_component/theme.dart';
import 'package:venus/src/utils/constants/colors.dart';

import 'bottom_divider.dart';

enum AppBarLeading {
  goBack,
  close,
  logo,
  none,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarLeading leading;
  final VoidCallback? onClose;
  final VoidCallback? onGoBack;
  final String? title;
  final Widget? bottom;
  final Color? backgroundColor = TColors.primary;
  final Widget? searchBar;
  final List<Widget>? actions;
  final List<ListMenuItem> moreActionsMenuItems;
  final Widget? customTitle;
  final NavigatorState? navigator;
  final double barHeight;
  final double bottomHeight;
  final bool showBottomDivider;

  static const double defaultBarHeight = 56;
  final bool centerTitle;

  CustomAppBar({
    Key? key,
    this.navigator,
    this.title,
    this.actions,
    this.bottom,
    this.barHeight = defaultBarHeight,
    this.bottomHeight = 0,
    this.searchBar,
    //this.backgroundColor,
    this.onClose,
    this.onGoBack,
    this.leading = AppBarLeading.goBack,
    this.moreActionsMenuItems = const [],
    this.customTitle,
    this.showBottomDivider = true,
    this.centerTitle = false,
  })  : preferredSize = Size.fromHeight(barHeight),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final nav = navigator ?? Navigator.of(context);

    return AppBar(
      centerTitle: centerTitle,
      title: customTitle ??
          CustomPadding.xSmall(
            left: false,
            top: false,
            bottom: false,
            child: CustomPadding.normalAll(
              left: leading == AppBarLeading.none || _omittedBackButton(nav),
              top: false,
              bottom: false,
              right: false,
              child: AppBarTitle(
                title: title ?? '',
                backgroundColor: backgroundColor,
                searchBar: searchBar,
                hideLeading:
                    leading == AppBarLeading.none || _omittedBackButton(nav),
              ),
            ),
          ),
      titleSpacing: 0,
      elevation: 0,
      scrolledUnderElevation: 2.0,
      shadowColor: ColorTheme.of(context).foreground50Color.withOpacity(0.25),
      automaticallyImplyLeading: false,
      leading: leading == AppBarLeading.none
          ? null
          : leading == AppBarLeading.logo
              ? const CustomPadding.normalAll(
                  right: false,
                  top: false,
                  bottom: false,
                  child: CustomPadding.smallVertical(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Icon(Icons.person, color: TColors.primary),
                    ),
                  ),
                )
              : leading == AppBarLeading.close
                  ? CustomPadding.normalHorizontal(
                      child: IconButton(
                        key: const Key('__KoyalAppBarCloseButton__'),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: TColors.white,
                        ),
                        onPressed: () => onClose?.call(),
                      ),
                    )
                  : (nav.canPop() || onGoBack != null) &&
                          leading == AppBarLeading.goBack
                      ? CustomPadding.normalHorizontal(
                          child: IconButton(
                            onPressed: () {
                              if (onGoBack == null) {
                                nav.maybePop();
                              } else {
                                onGoBack!.call();
                              }
                            },
                            key: const Key('__KoyalAppBarBackButton__'),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.arrow_back,
                                size: 24,
                                color: TColors.white,
                          ),
                        ))
                      : null,
      leadingWidth: leading == AppBarLeading.logo
          ? 75 /* logoWidth */ + 12 /* logoLeftPadding */
          : null,
      actions: [
        ..._actionWrapper(actions) ?? [],
        if (moreActionsMenuItems.isNotEmpty) ...[
          IconButton(
            key: const Key('__KoyalAppBarMoreActionsButton__'),
            icon: Icon(
              Icons.menu,
              size: 24,
              color: (backgroundColor == null ||
                      backgroundColor ==
                          ColorTheme.of(context).appbarBackgroundColor)
                  ? ColorTheme.of(context).primaryColor
                  : ColorTheme.of(context).foreground90Color,
            ),
            onPressed: onGoBack,
            constraints: const BoxConstraints(maxWidth: 48.0),
          ),
          const SizedBox(width: 4.0)
        ]
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
            color: backgroundColor ??
                ColorTheme.of(context).appbarBackgroundColor),
      ),
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: bottomHeight, child: bottom),
                  if (showBottomDivider) const SizedBox(),
                ],
              ),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: BottomDivider(
                dividerColor: ColorTheme.of(context).transparent,
              ),
            ),
    );
  }

  bool _omittedBackButton(NavigatorState nav) {
    return !nav.canPop() &&
            onGoBack == null &&
            leading == AppBarLeading.goBack ||
        centerTitle;
  }

  List<Widget>? _actionWrapper(List<Widget>? actions) {
    final actionIcons = <Widget>[];

    if (actions != null) {
      for (final action in actions) {
        actionIcons.add(
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 48.0),
            child: action,
          ),
        );
      }
      actionIcons.add(
        const SizedBox(
          width: 4.0,
        ),
      );
      return actionIcons;
    }
    return [];
  }
}
