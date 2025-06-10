import 'package:flutter/material.dart';

Widget profileCircle({
  double radius = 20.0,
  Color backgroundColor = Colors.grey,
  required Widget child
}) {
  final hsl = HSLColor.fromColor(backgroundColor);
  final lighter = hsl.withLightness((hsl.lightness + 0.1).clamp(0.0, 1.0)).toColor();
  final darker = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor();
  return Container(
    width: radius * 2,
    height: radius * 2,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [
          lighter,
          darker
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter
      )
    ),
    child: Center(
      child: child
    ),
  );
}