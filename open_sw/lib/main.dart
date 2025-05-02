import 'package:flutter/material.dart';
import 'package:open_sw/naver_directions_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Row(children: [NaverDirectionsButton()])),
    );
  }
}
