import 'package:flutter/material.dart';

Widget topAppBarSpacer(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight);
}

Widget topSearchAppBarSpacer(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 80);
}

Widget bottomNavigationBarSpacer(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).padding.bottom);
}

Widget spacingBox(){
  return SizedBox(height: 14, width: 14,);
}

Widget spacingBox_mini(){
  return SizedBox(height: 6, width: 6,);
}

Widget spacingBox_devider(){
  return Column(
    children: [
      spacingBox(),
      Container(
        width: double.infinity,
        height: 1,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(40),
        )
      ),
      spacingBox(),
    ],
  );
}
