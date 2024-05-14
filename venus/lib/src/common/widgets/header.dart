import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 24),
        LogoWidget(height: 60, width: 120),
        SizedBox(width: 24),
      ],
    );
  }
}

class LogoWidget extends StatelessWidget {
  final double height;
  final double width;

  const LogoWidget({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          "assets/icons/logo.svg",
          height: height,
          width: width,
        ),
      ],
    );
  }
}