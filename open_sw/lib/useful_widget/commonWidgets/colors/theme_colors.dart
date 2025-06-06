import 'package:flutter/material.dart';

const Color themeOrange = Color(0xFFFF8C26);
const Color themeLightOrange = Color(0xFFFF9933);
const Color themeDeepOrange = Color(0xFFFF6600);
const Color themeGreen = Color(0xFF52A658);

LinearGradient themeGradient() {
  return const LinearGradient(
    colors: [
      themeLightOrange,
      themeDeepOrange
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}