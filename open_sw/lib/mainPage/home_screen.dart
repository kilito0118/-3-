import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:open_sw/mainPage/friendPage/friend_page.dart';
import 'package:open_sw/mainPage/groupPage/group_page.dart';
import 'package:open_sw/mypage/my_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(
    initialPage: 1,
  ); // 페이지 컨트롤러
  int _currentIndex = 1;
  DocumentSnapshot? userInfo;

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      setState(() {
        userInfo = doc;
      });
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      //print('Firestore Error: ${e.code}');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Map<String, dynamic>? userData;
  @override
  Widget build(BuildContext context) {
    if (userInfo != null) {
      userData = userInfo!.data() as Map<String, dynamic>;
    }
    void handleNavTap(int index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex = index);
    }

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF2F2F2), Color(0xFFD9D9D9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView(
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse, // 웹에서 마우스 드래그 허용
              },
            ),
            physics: const ClampingScrollPhysics(),
            pageSnapping: true,
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: [
              FriendPage(),
              GroupPage(
                userName: userData?['nickName'] ?? "로그인되지 않음",
              ), //로그인 할 때 받아오도록 함.
              MyPage(
                name: userData?['nickName'] ?? '정보 찾기 실패',
                age: userData?['age'] ?? 0,
                gender: userData?['gender'] ?? '정보 찾기 실패',
              ),
            ], // 각 탭의 화면
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            //mouseCursor: MouseCursor.defer,
            selectedFontSize: 20,
            selectedIconTheme: IconThemeData(size: 35, color: Colors.black),
            currentIndex: _currentIndex,
            onTap: handleNavTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                label: '친구목록',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.diversity_3),
                label: '그룹 목록',
                //activeIcon: Text("하이라이트"),
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
            ],
          ),
        ),
      ),
    );
  }
}
