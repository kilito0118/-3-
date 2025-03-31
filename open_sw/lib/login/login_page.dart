import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_sw/login/password_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

final _formKey = GlobalKey<FormState>();

class LoginPageState extends State<LoginPage> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final buttonFocus = FocusNode();
  /*
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
        /*
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
            */
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
  }*/

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double belowWidth = (kIsWeb) ? 520 : screenWidth - 30;
    return Scaffold(
      backgroundColor: const Color(0xFFD9BBA0),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.2,
            left:
                ((screenWidth - belowWidth) / 2) > 0
                    ? ((screenWidth - belowWidth) / 2)
                    : 0,
            right:
                ((screenWidth - belowWidth) / 2) > 0
                    ? ((screenWidth - belowWidth) / 2)
                    : 0,
            bottom: 80,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: belowWidth),
            child: AutofillGroup(
              child: Form(
                key: _formKey, // GlobalKey<FormState>() 필요
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('로그인'),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        right: 40,
                        left: 40,
                        bottom: 20,
                      ),
                      child: TextFormField(
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next, // 다음 필드로 이동
                        onFieldSubmitted:
                            (_) => FocusScope.of(
                              context,
                            ).requestFocus(_passwordFocus),
                        autofillHints: const [
                          AutofillHints.username,
                          AutofillHints.email,
                        ],
                        style: TextStyle(fontSize: 25),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'or_not_official@naver.com',
                          hintStyle: Theme.of(context).textTheme.displayLarge!
                              .copyWith(color: Color(0x3f131420), fontSize: 25),
                          labelText: "(아이디)이메일",
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 40, left: 40, bottom: 20),
                      child: Passwordfield(
                        controller: _passwordController,
                        emailcontroller: _emailController,
                        focusNode: _passwordFocus,
                        nextFocusNode: buttonFocus,
                        isLoginPage: true,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // login();
                        TextInput.finishAutofillContext();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.disabled)) {
                              return Colors.grey;
                            }
                            if (states.contains(WidgetState.hovered)) {
                              return Colors.blue[200]!;
                            }
                            return Colors.transparent; // 기본
                          },
                        ),
                      ),
                      child: Text(
                        "로그인 하기",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
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
