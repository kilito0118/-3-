//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_sw/login/input_box_widget.dart';
import 'package:open_sw/login/signup_screen.dart';
import 'package:open_sw/mainPage/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

final _formKey = GlobalKey<FormState>();

class LoginPageState extends State<LoginPage> {
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffFF9933), Color(0xffFF6600)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
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
                        hintext: "비밀번호",
                        labelText: "Password",
                        nowfocus: _passwordFocus,
                        nextfocus: buttonFocus,
                        controller: _passwordController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: TextButton(
                        focusNode: buttonFocus,
                        onPressed: () {
                          login();
                          TextInput.finishAutofillContext();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Color(0xffffffff),
                          ),
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
                                    "로그인",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        '회원가입 하러 가기',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
