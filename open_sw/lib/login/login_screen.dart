//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_sw/login/widget/input_box_widget.dart';
import 'package:open_sw/login/signup_screen.dart';
import 'package:open_sw/login/widget/theme_button_white_widget.dart';
import 'package:open_sw/mainPage/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

final _formKey = GlobalKey<FormState>();

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final buttonFocus = FocusNode();

  Future<void> login() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
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
      debugPrint('Login Error: ${e.code}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffFF9933), Color(0xffFF6600)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 26, right: 26, bottom: 80),

              child: AutofillGroup(
                child: Form(
                  key: _formKey, // GlobalKey<FormState>() 필요
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 143.87,
                          right: 125.12,
                          left: 125.12,
                        ),
                        child: Image.asset("assets/Logo.png"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 60, bottom: 10),
                        child: InputBoxWidget(
                          hintext: "or_not_offical@naver.com",
                          nowfocus: _emailFocus,
                          nextfocus: _passwordFocus,
                          controller: _emailController,
                          labelText: "ID",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: InputBoxWidget(
                          isPassword: true,
                          hintext: "비밀번호",
                          labelText: "Password",
                          nowfocus: _passwordFocus,
                          nextfocus: buttonFocus,
                          controller: _passwordController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: ThemeButtonWhiteWidget(
                          text: '로그인',
                          onPressed: () {
                            login();
                            TextInput.finishAutofillContext();
                          },
                          focusNode: buttonFocus,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                              endIndent: 10,
                            ),
                          ),
                          Text(
                            '혹은',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                              indent: 10,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
                      ThemeButtonWhiteWidget(
                        text: '회원가입',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        focusNode: FocusNode(),
                      ),
                    ],
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
