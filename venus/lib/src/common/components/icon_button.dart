import 'package:flutter/material.dart';

class AIIconButton extends StatelessWidget {
  const AIIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  final void Function()? onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      // splashRadius: 8,
      onPressed: onPressed,
      icon: icon,
      iconSize: 16,
      padding: const EdgeInsets.all(0),
      splashColor: Colors.white,
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.white)),
    );
  }
}
