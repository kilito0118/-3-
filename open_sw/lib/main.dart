import 'package:flutter/material.dart';
import 'package:open_sw/login/login_page.dart';
import 'package:open_sw/login/signup_page.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignupPage());
  }
}
