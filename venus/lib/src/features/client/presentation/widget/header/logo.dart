import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: InkWell(
            hoverColor: Colors.white,
            focusColor: Colors.white,
            highlightColor: Colors.white,
            onTap: () {
              context.go("/");
            },
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  "assets/icons/logo.svg",
                  height: 40,
                  width: 80,
                )),
          ),
        )
      ],
    );
  }
}
