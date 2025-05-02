import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String hintext;
  final int type;
  const InputBox({super.key, required this.hintext, required this.type});
  //0 이름
  // 1 나이
  // 2 ID
  // 3 비밀번호
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType:
          type == 1
              ? TextInputType.number
              : type == 0
              ? TextInputType.name
              : type == 2
              ? TextInputType.emailAddress
              : TextInputType.visiblePassword,
      obscureText: type == 3,
      decoration: InputDecoration(
        hintText: hintext,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: Colors.grey[500]!,
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
