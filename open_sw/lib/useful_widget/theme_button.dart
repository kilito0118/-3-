import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  final String text;
  final FocusNode focusNode;
  final VoidCallback onPressed;
  const ThemeButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFF9933), Color(0xffFF6600)], // 그래디언트 색상
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15), // 버튼 모서리 둥글게
        ),
        child: TextButton(
          onPressed: () {
            onPressed();
          },
          style: ButtonStyle(
            enableFeedback: false,
            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
          ),
          child: Text(
            text,
            style: TextStyle(color: Color(0xffffffff), fontSize: 16),
          ),
        ),
      ),
    );
  }
}
