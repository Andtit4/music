import 'package:flutter/material.dart';

class IconButtonCustom extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconColor;
  const IconButtonCustom(
      {super.key,
      this.backgroundColor,
      this.height,
      this.icon,
      this.iconColor,
      this.borderRadius,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ), child: Icon(icon, color: iconColor),
    );
  }
}
