import 'package:flutter/material.dart';

const Color themeOrange = Color(0xFFFF8C26);
const Color themeLightOrange = Color(0xFFFF9933);
const Color themeYellow = Color(0xFFFBC02D);
const Color themeDeepOrange = Color(0xFFFF6600);
const Color themeGreen = Color(0xFF52A658);
const Color themeRed = Color(0xFFFF5252);
const Color themePageColor = Color(0xFFF2F2F2);

LinearGradient themeGradient() {
  return const LinearGradient(
    colors: [
      themeLightOrange,
      themeDeepOrange
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topCenter,
    stops: [
      0.3,
      0.9,
    ],
  );
}