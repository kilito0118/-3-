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

Widget spacingBox_withComment(String title){
  return Padding(
    padding: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 14),
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

Widget gestureBar(){
  return Center(
    child: Container(
      width: 72,
      height: 4,
      margin: EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.black.withAlpha(40),
      ),
    )
  );
}
