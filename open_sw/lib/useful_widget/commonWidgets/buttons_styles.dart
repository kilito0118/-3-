import 'package:flutter/material.dart';
import 'text_style_form.dart';

ButtonStyle btn_normal({
  Color? foregroundColor,
  Color? backgroundColor,
}){
  return TextButton.styleFrom(
    foregroundColor: foregroundColor ?? Colors.black,
    backgroundColor: backgroundColor ?? Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14)
    ),
    textStyle: contentsDetail,
    alignment: Alignment.center,
    minimumSize: Size(0, 0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}