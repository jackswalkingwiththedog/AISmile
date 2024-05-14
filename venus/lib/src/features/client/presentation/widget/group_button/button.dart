import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';

class ImageButton extends StatelessWidget {
  const ImageButton(
      {super.key,
      required this.icon,
      required this.path,
      required this.title,
      this.onTap});

  final String icon;
  final String title;
  final String path;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Material(
      shape: ContinuousRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: BorderSide(
            color: HexColor("#DB1A20"),
            width: 1,
          )),
      child: InkWell(
          onTap: () {
            if (path == "" && onTap != null) {
              onTap!();
            } else {
              context.go(path);
            }
          },
          child: SizedBox(
            width: size.width > 1024 ? 168 : (size.width - 72) / 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: Image.asset(icon, fit: BoxFit.fill),
                  ),
                  const SizedBox(height: 8),
                  Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: HexColor("#DB1A20"),
                          fontSize: size.width > 1024 ? 16 : 12,
                          fontWeight: FontWeight.w900))
                ],
              ),
            ),
          )),
    );
  }
}
