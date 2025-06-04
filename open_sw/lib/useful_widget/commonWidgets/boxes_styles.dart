import 'dart:ui';
import 'package:flutter/material.dart';
import 'common_widgets.dart';

Widget BlurredBox({
  required Widget child,
  double? width,
  double? height,
  double topRad = 0.0,
  double bottomRad = 0.0,
  double horizontalPadding = 20.0,
  double verticalPadding = 16.0,
  int alpha = 160
}) {
  return Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topRad),
        topRight: Radius.circular(topRad),
        bottomLeft: Radius.circular(bottomRad),
        bottomRight: Radius.circular(bottomRad),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(36),
          blurRadius: 8,
          offset: Offset(0, 0),
          spreadRadius: 0,
        )
      ]
    ),
    child: ClipRRect (
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(alpha),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRad),
              topRight: Radius.circular(topRad),
              bottomLeft: Radius.circular(bottomRad),
              bottomRight: Radius.circular(bottomRad),
            ),
            border: Border.all(
              color: Colors.white.withAlpha(160),
              width: 1.2,
            )
          ),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          child: child,
        ),
      ),
    ),
  );
}

Widget ContentsBox({
  required Widget child,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: child,
  );
}

Widget IconBox({
  required IconData icon,
  required Color color,
}) {
  return Container(
    width: 28.0,
    height: 28.0,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Icon(icon, color: Colors.white, size: 16,),
  );
}