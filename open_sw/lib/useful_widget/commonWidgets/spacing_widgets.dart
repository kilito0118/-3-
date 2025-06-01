import 'package:flutter/material.dart';

Widget topAppBarSpacer(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight);
}

Widget topSearchAppBarSpacer(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 80);
}

Widget spacingBox(){
  return SizedBox(height: 14, width: 14,);
}