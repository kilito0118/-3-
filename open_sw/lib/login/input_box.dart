import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String hintext;
  const InputBox({super.key, required this.hintext});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintext,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: Colors.grey[350]!,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          borderSide: BorderSide(
            color: Colors.black,
            width: 3,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}
