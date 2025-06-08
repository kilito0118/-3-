import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/login/widget/input_box_widget.dart';
import 'package:open_sw/login/questions_page1.dart';
import 'package:open_sw/login/logic/regist_users.dart';
import 'package:open_sw/useful_widget/theme_button.dart';

Future<bool> isNicknameAvailable(String nickname) async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .get();
  //print(snapshot.docs.isEmpty);
  return snapshot.docs.isEmpty;
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController idcontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController passwordcheckcontroller = TextEditingController();

  FocusNode idfocus = FocusNode();
  FocusNode agefocus = FocusNode();
  FocusNode genderfocus = FocusNode();
  FocusNode namefocus = FocusNode();
  FocusNode passwordfocus = FocusNode();
  FocusNode passwordcheckfocus = FocusNode();
  FocusNode buttonfocus = FocusNode();
  String? selectedGender;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //double belowWidth = (kIsWeb) ? 520 : screenWidth - 30;

    Future<void> signUp() async {
      if (namecontroller.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("이름을 입력해주세요.")));
        return;
      }
      if (agecontroller.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("나이를 입력해주세요.")));
        return;
      }
      if (selectedGender == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("성별을 선택해주세요.")));
        return;
      }

      if (idcontroller.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("ID를 입력해주세요.")));
        return;
      }
      if (passwordcontroller.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("비밀번호를 입력해주세요.")));
        return;
      }
      if (passwordcontroller.text != passwordcheckcontroller.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("비밀번호가 일치하지 않습니다.")));
        return;
      }

      if (_formKey.currentState!.validate()) {
        try {
          // 1. Firebase 인증으로 계정 생성
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: idcontroller.text,
                password: passwordcontroller.text,
              );

          // 2. 추가 정보 Firestore에 저장
          registUsers(
            namecontroller.text,
            userCredential,
            idcontroller.text,
            int.parse(agecontroller.text),
            selectedGender!,
            false,
          );

          // 3. 성공 후 화면 전환
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => QuestionsPage1()),
          );
        } on FirebaseAuthException catch (e) {
          // 에러 메시지를 스낵바로 출력
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.code)));
          debugPrint('Sign Up Error: ${e.code}');
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF2F2F2), Color(0xFFD9D9D9)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "회원가입",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.13,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              bottom: 60,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "처음이신가요?",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(5),

                          child: InputBoxWidget(
                            hintext: "이름",
                            controller: namecontroller,
                            labelText: "이름",
                            nextfocus: agefocus,
                            nowfocus: namefocus,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),

                          child: InputBoxWidget(
                            hintext: "20",
                            controller: agecontroller,
                            labelText: "나이",
                            nowfocus: agefocus,
                            nextfocus: genderfocus,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: DropdownButtonFormField<String>(
                            focusNode: genderfocus,
                            icon: Text(""),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.grey[500]!,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(40),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),

                              hintText: '성별',
                            ),
                            value: selectedGender,
                            dropdownColor: Color.fromARGB(62, 199, 196, 196),

                            //itemHeight: 16,
                            items:
                                ['남', '여']
                                    .map(
                                      (gender) => DropdownMenuItem<String>(
                                        value: gender,
                                        alignment: Alignment.center,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amberAccent,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                          child: Text(gender),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGender = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: SizedBox(
                      height: 48,
                      child: InputBoxWidget(
                        hintext: "이메일 형식으로 적어주세요.",
                        controller: idcontroller,
                        nowfocus: idfocus,
                        nextfocus: passwordfocus,
                        labelText: "ID",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: SizedBox(
                      height: 48,
                      child: InputBoxWidget(
                        hintext: "Password",
                        nowfocus: passwordfocus,
                        controller: passwordcontroller,
                        labelText: "Password",
                        nextfocus: passwordcheckfocus,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: SizedBox(
                      height: 48,
                      child: InputBoxWidget(
                        hintext: "Password 확인",
                        controller: passwordcheckcontroller,
                        labelText: "Password 확인",
                        nextfocus: buttonfocus,
                        nowfocus: passwordcheckfocus,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: Row(
                      children: [
                        Expanded(
                          child: ThemeButton(
                            text: "가입하고 시작하기",
                            onPressed: () {
                              signUp();
                            },
                            focusNode: buttonfocus,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
