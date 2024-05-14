import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class AITextFormField extends StatelessWidget {
  const AITextFormField({
    Key? key,
    this.onChanged,
    this.keyboardType,
    this.prefixIcon,
    this.hintText,
    this.suffixIcon,
    this.obscureText,
    this.maxLines,
    this.inputFormatters,
    this.initialValue,
    this.enabled,
    this.borderColor,
    this.contentPadding,
  }) : super(key: key);

  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? hintText;
  final Widget? suffixIcon;
  final bool? obscureText;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool? enabled;
  final Color? borderColor;
  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: HexColor("#DB1A20"))
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? HexColor("#DB1A20"))),
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20, color: HexColor("#DB1A20")),
        hintText: hintText,
        suffixIconColor: HexColor("#DB1A20"),
        hintStyle: const TextStyle(fontSize: 14),
        // suffixIcon: suffixIcon,
      ),
      cursorColor: HexColor("#DB1A20"),
      initialValue: initialValue,
      maxLines: maxLines ?? 1,
      enabled: enabled ?? true,
    );
  }
}
