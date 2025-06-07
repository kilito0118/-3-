import 'dart:ui';

import 'package:flutter/material.dart';

Widget mainTitle(String title){
  return Padding(
    padding: EdgeInsets.only(left: 6, right: 6, top: 14),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.1,
        letterSpacing: 0.0,
      ),
    ),
  );
}

Widget subTitle(String title){
  return Padding(
    padding: EdgeInsets.only(left: 8, right: 8, top: 14),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.black.withAlpha(100),
        fontSize: 15,
        fontWeight: FontWeight.bold,
        height: 1.1,
        letterSpacing: 0.0,
      ),
    ),
  );
}

const TextStyle contentsTitle = TextStyle(
  color: Colors.black,
  fontSize: 26,
  fontWeight: FontWeight.bold,
  height: 1.1,
  letterSpacing: 0.0,
);

const TextStyle contentsBig = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontWeight: FontWeight.normal,
  height: 1.1,
  letterSpacing: 0.0,
);

TextStyle contentsNormal({Color color = Colors.black, FontWeight fontWeight = FontWeight.normal}){
  return TextStyle(
    color: color,
    fontSize: 16,
    fontWeight: fontWeight,
    height: 1.1,
    letterSpacing: 0.0,
  );
}

TextStyle contentsDetail = TextStyle(
  color: Colors.black.withAlpha(140),
  fontSize: 14,
  fontWeight: FontWeight.normal,
  height: 1.1,
  letterSpacing: 0.0,
);