import 'package:flutter/material.dart';
//import 'package:open_sw/naver_directions_button.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 네이버 지도 연결 버튼튼
      // home: Scaffold(body: Row(children: [NaverDirectionsButton()])),
      home: MainScreen(),
      routes: {'/main': (context) => MainScreen()},
    );
  }
}
