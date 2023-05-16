import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputCustom extends StatelessWidget {
  final double? width;
  final double? height;
  final String? hintText;
  final Color? hintColor;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final Color? inputColor;
  const InputCustom(
      {super.key,
      required this.borderRadius,
      this.height,
      this.hintText,
      this.inputColor,
      this.hintColor,
      this.prefixIcon,
      this.margin,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: TextFormField(
        style: GoogleFonts.poppins(color: hintColor),
        decoration: InputDecoration(
          filled: true,
          fillColor: inputColor,
          hintText: hintText,
          prefixIcon: prefixIcon,
          hintStyle: GoogleFonts.poppins(color: hintColor),
          labelStyle: GoogleFonts.poppins(color: hintColor),
          enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius, borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius, borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
