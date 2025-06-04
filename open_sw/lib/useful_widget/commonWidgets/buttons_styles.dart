import 'package:flutter/material.dart';
import 'text_style_form.dart';
import 'colors/theme_colors.dart';

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

class SubmitButtonNormal extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const SubmitButtonNormal({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<SubmitButtonNormal> createState() => _SubmitButtonNormalState();
}

class _SubmitButtonNormalState extends State<SubmitButtonNormal> {
  // 눌렀을때 효과
  double _scale = 1.0;
  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }
  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }
  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: themeGradient(),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x7FFF9933),
                blurRadius: 12,
                offset: Offset(0, 6),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.1,
              letterSpacing: 0.0,
            ),
          ),
        ),
      ),
    );
  }
}