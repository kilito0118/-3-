import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:open_sw/mainPage/friendPage/friend_page.dart';
import 'package:open_sw/mainPage/groupPage/group_page.dart';
import 'package:open_sw/mypage/my_page.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

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

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: themePageColor,
      appBar: defaultAppBar(),
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
            email: userData?['email'] ?? '정보 찾기 실패',
          ),
        ], // 각 탭의 화면
      ),
      bottomNavigationBar: blurredBox(
          topRad: 32,
          bottomRad: 0.0,
          horizontalPadding: 14.0,
          verticalPadding: 6.0,
          shadowAlpha: 36,
          alpha: 160,
          blurRadius: 16,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory, // 퍼짐 효과 제거
              highlightColor: Colors.transparent,    // 터치 시 강조 효과 제거
            ),
            child:BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.black.withAlpha(200),
              unselectedItemColor: Colors.black.withAlpha(100),
              currentIndex: _currentIndex,
              onTap: handleNavTap,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedFontSize: 14,
              unselectedFontSize: 14,
              iconSize: 32,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_list_rounded),
                  label: '팔로우 목록',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups),
                  label: '그룹 목록',
                  //activeIcon: Text("하이라이트"),
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: '내 정보'
                ),
              ],
            ),
          )
      ),
    );
  }
}
