import 'dart:ui';
import 'package:flutter/material.dart';

Widget blurredBox({
  required Widget child,
  Color backGroundColor = Colors.white,
  double? width,
  double? height,
  double topRad = 20.0,
  double bottomRad = 20.0,
  double horizontalPadding = 20.0,
  double verticalPadding = 16.0,
  int alpha = 180,
  int shadowAlpha = 36,
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
          color: Colors.black.withAlpha(shadowAlpha),
          blurRadius: 8,
          offset: Offset(0, 0),
          spreadRadius: 0,
        ),
      ],
    ),
    child: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backGroundColor.withAlpha(alpha),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRad),
              topRight: Radius.circular(topRad),
              bottomLeft: Radius.circular(bottomRad),
              bottomRight: Radius.circular(bottomRad),
            ),
            border: Border.all(
              color: Colors.white.withAlpha(alpha),
              width: 1.2,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: child,
        ),
      ),
    ),
  );
}

Widget contentsBox({required Widget child, double? width, double? height}) {
  return Container(
    width: width,
    height: height,
    clipBehavior: Clip.antiAlias,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: child,
  );
}
