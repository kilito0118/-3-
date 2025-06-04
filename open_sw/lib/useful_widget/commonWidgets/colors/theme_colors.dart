import 'package:flutter/material.dart';

LinearGradient themeGradient() {
  return const LinearGradient(
    colors: [
      Color(0xFFFF9933),
      Color(0xFFFF6600),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}