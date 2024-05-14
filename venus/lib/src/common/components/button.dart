import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AIButton extends StatelessWidget {
  const AIButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.icon,
    this.style
  }) : super(key: key);

  final void Function()? onPressed;
  final IconData? icon;
  final Widget child;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style ?? ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.all(16)),
        backgroundColor: MaterialStatePropertyAll(HexColor("#DB1A20")),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
        )
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon == null ? const SizedBox(width: 0) : Icon(icon, size: 16, color: Colors.white),
          icon == null ? const SizedBox(width: 0) : const SizedBox(width: 8),
          child
        ],
      ),
    );
  }
}
