import 'package:flutter/material.dart';

class ListMenuItem {
  Key? key;
  Widget? icon;
  String title;
  bool thickDivider = false;
  String dividerTitle;
  List<ListMenuItem>? items;
  void Function(BuildContext)? onTap;
  Widget? trailing;
  bool isHeader;

  ListMenuItem({
    this.key,
    this.icon,
    required this.title,
    this.thickDivider = false,
    this.items,
    this.onTap,
    this.dividerTitle = '',
    this.trailing,
    this.isHeader = false,
  });
}
