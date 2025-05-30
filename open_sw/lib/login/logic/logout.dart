import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/login/login_screen.dart';

Future<void> performLogout(context) async {
  try {
    await FirebaseAuth.instance.signOut();
    //print('로그아웃 성공: ${DateTime.now()}');
    // ignore: unused_catch_clause
  } on FirebaseAuthException catch (e) {
    //print('로그아웃 실패: ${e.code}');
  }
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (route) => false,
  );
}
