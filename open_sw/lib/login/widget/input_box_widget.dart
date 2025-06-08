import 'package:flutter/material.dart';

class InputBoxWidget extends StatelessWidget {
  final String hintext;
  final String labelText;
  final bool isPassword;
  final FocusNode nowfocus;
  final FocusNode nextfocus;
  final TextEditingController controller;
  const InputBoxWidget({
    super.key,
    required this.hintext,
    required this.labelText,
    required this.nowfocus,
    required this.nextfocus,
    required this.controller,
    this.isPassword = false,
  });
  //0 이름
  // 1 나이
  // 2 ID
  // 3 비밀번호
  @override
  Widget build(BuildContext context) {
    return InputField(
      isPassword: isPassword,
      controller: controller,
      label: labelText,
      hintext: hintext,
      nextfocus: nextfocus,
      nowfocus: nowfocus,
    );
    /*
     Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color.fromRGBO(255, 255, 255, 0.6),
      ),
      child: TextFormField(
        focusNode: nowfocus,
        textInputAction: TextInputAction.next, // 다음 필드로 이동
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(nextfocus),
        autofillHints: const [AutofillHints.username, AutofillHints.email],
        style: TextStyle(fontSize: 20),
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          hintText: hintext,

          hintStyle: TextStyle(color: Color(0xffffffff), fontSize: 16),
          labelText: labelText,

          labelStyle: TextStyle(fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(
              color: Color.fromRGBO(255, 255, 255, 0.6),
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(
              color: Color.fromRGBO(255, 255, 255, 0.6),
              width: 4,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
  */
  }
}

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final dynamic hintext;
  final dynamic nowfocus;
  final dynamic nextfocus;
  final bool isPassword;

  const InputField({
    super.key,
    required this.label,
    required this.controller,

    required this.hintext,
    required this.nowfocus,
    required this.nextfocus,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        //SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            obscureText: isPassword ?? false,
            focusNode: nowfocus,
            controller: controller,
            onSubmitted: (_) => FocusScope.of(context).requestFocus(nextfocus),
            decoration: InputDecoration(
              hintText: hintext,
              label: Text(label),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }
}
