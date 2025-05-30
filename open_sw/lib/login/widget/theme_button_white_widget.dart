import 'package:flutter/material.dart';

class ThemeButtonWhiteWidget extends StatelessWidget {
  final String text;
  final FocusNode focusNode;

  final VoidCallback onPressed;

  const ThemeButtonWhiteWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.focusNode,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      focusNode: focusNode,
      onPressed: () {
        onPressed();
      },
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          onPressed();
        } else {
          // 포커스가 해제되었을 때의 동작을 여기에 추가할 수 있습니다.
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Color(0xffffffff)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Flexible(
            child: SizedBox(
              height: 44,
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
