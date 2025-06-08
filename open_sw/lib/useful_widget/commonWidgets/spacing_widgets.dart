import 'package:flutter/material.dart';

const double padding_big = 18.0;
const double padding_mid = 16.0;
const double padding_small = 12.0;

Widget topAppBarSpacer(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight);
}

Widget topSearchAppBarSpacer(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).padding.top + kToolbarHeight + 76,
  );
}

Widget bottomNavigationBarSpacer(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).padding.bottom);
}

Widget spacingBox() {
  return SizedBox(height: padding_small, width: padding_small);
}

Widget spacingBoxMini() {
  return SizedBox(height: 5, width: 5);
}

Widget spacingBoxDevider() {
  return Column(
    children: [
      spacingBox(),
      Container(
        width: double.infinity,
        height: 1,
        decoration: BoxDecoration(color: Colors.black.withAlpha(40)),
      ),
      spacingBox(),
    ],
  );
}

Widget spacingBoxWithComment(String title) {
  return Padding(
    padding: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: padding_small),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.black.withAlpha(100),
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.1,
        letterSpacing: 0.0,
      ),
    ),
  );
}

Widget gestureBar() {
  return Center(
    child: Container(
      width: 72,
      height: 4,
      margin: EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.black.withAlpha(40),
      ),
    ),
  );
}
