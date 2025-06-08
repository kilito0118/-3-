import 'package:flutter/material.dart';
import 'spacing_widgets.dart';

Widget mainTitle(String title) {
  return Padding(
    padding: EdgeInsets.only(left: 5, right: 5, top: padding_small),
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

Widget subTitle(String title) {
  return Padding(
    padding: EdgeInsets.only(left: 6, right: 6, top: padding_small),
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

TextStyle contentsNormal({
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TextStyle(
    color: color,
    fontSize: 16,
    fontWeight: fontWeight,
    height: 1.1,
    letterSpacing: 0.0,
  );
}

TextStyle contentsTitle({Color color = Colors.black}) {
  return TextStyle(
    color: color,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.1,
    letterSpacing: 0.0,
  );
}

TextStyle contentsBig({
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TextStyle(
    color: color,
    fontSize: 18,
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
