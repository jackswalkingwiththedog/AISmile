import 'package:flutter/material.dart';

class ProgressIcon extends StatelessWidget {
  const ProgressIcon({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          color: color,
        ),
      ),
    );
  }
}