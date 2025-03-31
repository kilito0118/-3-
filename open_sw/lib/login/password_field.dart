import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Passwordfield extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController emailcontroller;
  final FocusNode focusNode;
  final bool isLoginPage;
  final FocusNode nextFocusNode;
  const Passwordfield({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
    this.isLoginPage = false,
    required this.emailcontroller,
  });

  @override
  PasswordfieldState createState() => PasswordfieldState();
}

class PasswordfieldState extends State<Passwordfield> {
  List<String> passStone = ['⚫', '⚪'];
  //final FocusNode _focusNode = FocusNode();
  /*
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: widget.emailcontroller.text,
        password: widget.controller.text,
      );
      //print(userCredential);

      if (mounted) {
        // 로그인 성공 시 처리
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      // 에러 메시지를 스낵바로 출력
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }
  */

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.focusNode.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 18,
          child: Text(
            _buildPassword(),
            style: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontFamily: 'NotoEmoji'),
          ),
        ),
        TextFormField(
          textInputAction:
              widget.isLoginPage
                  ? TextInputAction.go
                  : TextInputAction.next, // 엔터 키 레이블 변경
          onFieldSubmitted: (value) {
            if (widget.isLoginPage) {
              //login();
              TextInput.finishAutofillContext();
            } else {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          },
          showCursor: false,
          obscureText: true,
          obscuringCharacter: " ",

          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: (value) {
            setState(() {});
          },
          enableInteractiveSelection: false,
          style: const TextStyle(color: Colors.transparent, fontSize: 22),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: 'password',
            hintStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: Color(0x3f131420),
              fontSize: 25,
            ),
            labelText: "비밀번호",
            labelStyle: Theme.of(context).textTheme.bodySmall,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.zero),
              borderSide: BorderSide(
                color: Colors.black,
                width: 4,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _buildPassword() {
    return List.generate(
      widget.controller.text.length,
      (index) => passStone[index % 2],
    ).join();
  }
}
