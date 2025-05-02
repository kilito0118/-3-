//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/login/input_box.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    String? selectedGender;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //double belowWidth = (kIsWeb) ? 520 : screenWidth - 30;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0x3f9E9E9E)], // 그래디언트 색상 설정
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: null,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.2,
              left: screenWidth * 0.2,
              right: screenWidth * 0.2,
              bottom: 80,
            ),
            child: Column(
              children: [
                Text(
                  "처음이신가요?",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: InputBox(hintext: "이름"),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: InputBox(hintext: "나이"),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: DropdownButtonFormField<String>(
                          icon: Text(""),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey[350]!,
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
                          items:
                              ['남', '여']
                                  .map(
                                    (gender) => DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(gender),
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
                  child: InputBox(hintext: "ID"),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: InputBox(hintext: "Password"),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: InputBox(hintext: "Password 확인"),
                ),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber,
                                  Colors.amberAccent,
                                ], // 그래디언트 색상
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // 버튼 모서리 둥글게
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                enableFeedback: false,
                                overlayColor: WidgetStateProperty.all<Color>(
                                  Colors.transparent,
                                ),
                              ),
                              child: Text('가입하기'),
                            ),
                          ),
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
    );
  }
}
