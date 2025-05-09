import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  final String text;
  const ThemeButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber, Colors.amberAccent], // 그래디언트 색상
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15), // 버튼 모서리 둥글게
                ),
                child: TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    enableFeedback: false,
                    overlayColor: WidgetStateProperty.all<Color>(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(text),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
