
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:venus/src/ui_component/custom_appbar.dart';
import 'package:venus/src/ui_component/custom_safe_area.dart';
import 'package:venus/src/utils/platform_utils.dart';


class CustomScaffold extends StatelessWidget {
  final Key? scaffoldKey;
  final CustomAppBar? appBar; //
  final Widget? body; //
  final Widget? floatingActionButton; //
  final FloatingActionButtonLocation? floatingActionButtonLocation; //
  final FloatingActionButtonAnimator? floatingActionButtonAnimator; //
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer; //
  final void Function(bool)? onDrawerChanged;
  final Widget? endDrawer;
  final void Function(bool)? onEndDrawerChanged;
  final Widget? bottomNavigationBar; //
  final Widget? bottomSheet; //
  final Color? backgroundColor; //
  final bool? resizeToAvoidBottomInset; //
  final bool primary; //
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody; //
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;
  final bool showInternetAlert;

  final CustomSafeArea? safeAreaCustomSettings;
  final CustomSafeArea? safeAreaBarCustomSettings;
  final CustomSafeArea? safeAreaSheetCustomSettings;

  const CustomScaffold({
    Key? key,
    this.scaffoldKey,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
    this.safeAreaCustomSettings,
    this.safeAreaBarCustomSettings,
    this.safeAreaSheetCustomSettings,
    this.showInternetAlert = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        key: scaffoldKey,
        appBar: appBar,
        body: body != null
            ? SafeArea(
                key: safeAreaCustomSettings?.key,
                left: safeAreaCustomSettings?.left ?? true,
                top: safeAreaCustomSettings?.top ?? true,
                right: safeAreaCustomSettings?.right ?? true,
                bottom: safeAreaCustomSettings?.bottom ?? true,
                minimum: safeAreaCustomSettings?.minimum ?? EdgeInsets.zero,
                maintainBottomViewPadding: safeAreaCustomSettings?.maintainBottomViewPadding ?? false,
                child: !PlatformUtils.isLinux && !PlatformUtils.isWeb
                    ? Column(
                        children: [
                          if (showInternetAlert)
                            StreamBuilder<ConnectivityResult>(
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data == ConnectivityResult.none) {
                                    return _noInternetAlert(context);
                                  }
                                } else {
                                  return FutureBuilder<ConnectivityResult>(
                                    future: Connectivity().checkConnectivity(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data == ConnectivityResult.none) {
                                        return _noInternetAlert(context);
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                              stream: Connectivity().onConnectivityChanged,
                            ),
                          Expanded(child: body!),
                        ],
                      )
                    : body!,
              )
            : null,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
        persistentFooterButtons: persistentFooterButtons,
        drawer: drawer,
        onDrawerChanged: onDrawerChanged,
        endDrawer: endDrawer,
        onEndDrawerChanged: onEndDrawerChanged,
        bottomNavigationBar: bottomNavigationBar != null
            ? SafeArea(
                key: safeAreaBarCustomSettings?.key,
                left: safeAreaBarCustomSettings?.left ?? true,
                top: safeAreaBarCustomSettings?.top ?? false,
                right: safeAreaBarCustomSettings?.right ?? true,
                bottom: safeAreaBarCustomSettings?.bottom ?? true,
                minimum: safeAreaBarCustomSettings?.minimum ?? EdgeInsets.zero,
                maintainBottomViewPadding: safeAreaBarCustomSettings?.maintainBottomViewPadding ?? false,
                child: bottomNavigationBar!,
              )
            : null,
        bottomSheet: bottomSheet != null
            ? SafeArea(
                key: safeAreaSheetCustomSettings?.key,
                left: safeAreaSheetCustomSettings?.left ?? true,
                top: safeAreaSheetCustomSettings?.top ?? false,
                right: safeAreaSheetCustomSettings?.right ?? true,
                bottom: safeAreaSheetCustomSettings?.bottom ?? true,
                minimum: safeAreaSheetCustomSettings?.minimum ?? EdgeInsets.zero,
                maintainBottomViewPadding: safeAreaSheetCustomSettings?.maintainBottomViewPadding ?? false,
                child: bottomSheet!,
              )
            : null,
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        primary: primary,
        drawerDragStartBehavior: drawerDragStartBehavior,
        extendBody: extendBody,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        drawerScrimColor: drawerScrimColor,
        drawerEdgeDragWidth: drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
        restorationId: restorationId,
      );

  Widget _noInternetAlert(BuildContext context) => const Text('No internet');
}
