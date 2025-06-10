import 'package:flutter/material.dart';
import 'text_style_form.dart';
import 'colors/theme_colors.dart';
import 'spacing_widgets.dart';

ButtonStyle btnBig({Color? themeColor, int alpha = 40}) {
  Color foregroundColor;
  Color backgroundColor;

  if (themeColor == null) {
    foregroundColor = Colors.black;
    backgroundColor = Colors.white;
  } else {
    foregroundColor = themeColor;
    backgroundColor = themeColor.withAlpha(alpha);
  }
  return TextButton.styleFrom(
    foregroundColor: foregroundColor,
    backgroundColor: backgroundColor,
    padding: const EdgeInsets.symmetric(
      horizontal: paddingBig,
      vertical: paddingMid,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    textStyle: contentsNormal(),
    alignment: Alignment.center,
    minimumSize: Size(0, 0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

ButtonStyle btnNormal({Color? themeColor}) {
  Color foregroundColor;
  Color backgroundColor;

  if (themeColor == null) {
    foregroundColor = Colors.black;
    backgroundColor = Colors.black.withAlpha(20);
  } else {
    foregroundColor = themeColor;
    backgroundColor = themeColor.withAlpha(40);
  }
  return TextButton.styleFrom(
    foregroundColor: foregroundColor,
    backgroundColor: backgroundColor,
    padding: const EdgeInsets.symmetric(
      horizontal: paddingBig,
      vertical: paddingSmall,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    textStyle: contentsNormal(),
    alignment: Alignment.center,
    minimumSize: Size(0, 0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

ButtonStyle btnTransparent({Color? themeColor}) {
  Color foregroundColor;
  Color backgroundColor;

  if (themeColor == null) {
    foregroundColor = Colors.black;
    backgroundColor = Colors.transparent;
  } else {
    foregroundColor = themeColor;
    backgroundColor = Colors.transparent;
  }
  return TextButton.styleFrom(
    foregroundColor: foregroundColor,
    backgroundColor: backgroundColor,
    padding: const EdgeInsets.symmetric(
      horizontal: paddingBig,
      vertical: paddingSmall,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    textStyle: contentsNormal(),
    alignment: Alignment.center,
    minimumSize: Size(0, 0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

ButtonStyle btnSmall({Color? themeColor}) {
  Color foregroundColor;
  Color backgroundColor;

  if (themeColor == null) {
    foregroundColor = Colors.black;
    backgroundColor = Colors.black.withAlpha(20);
  } else {
    foregroundColor = themeColor;
    backgroundColor = themeColor.withAlpha(40);
  }
  return TextButton.styleFrom(
    foregroundColor: foregroundColor,
    backgroundColor: backgroundColor,
    padding: const EdgeInsets.symmetric(horizontal: paddingSmall, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: contentsDetail,
    alignment: Alignment.center,
    minimumSize: Size(0, 0),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

// 일반 버튼
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
            boxShadow: [
              BoxShadow(
                color: themeLightOrange.withAlpha(140),
                blurRadius: 10,
                offset: Offset(0, 8),
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

// 큰 버튼
class SubmitButtonBig extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const SubmitButtonBig({super.key, required this.text, required this.onTap});

  @override
  State<SubmitButtonBig> createState() => _SubmitButtonBigState();
}

class _SubmitButtonBigState extends State<SubmitButtonBig> {
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: themeGradient(),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeLightOrange.withAlpha(140),
                blurRadius: 10,
                offset: Offset(0, 8),
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

// async 지원 버튼
class SubmitButtonAsync extends StatefulWidget {
  final String text;
  final Future<void> Function() onTap;

  const SubmitButtonAsync({super.key, required this.text, required this.onTap});

  @override
  State<SubmitButtonAsync> createState() => SubmitButtonAsyncState();
}

class SubmitButtonAsyncState extends State<SubmitButtonAsync> {
  // 눌렀을때 효과
  double _scale = 1.0;
  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    setState(() => _scale = 1.0);
    await widget.onTap();
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: themeGradient(),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeLightOrange.withAlpha(140),
                blurRadius: 10,
                offset: Offset(0, 8),
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
