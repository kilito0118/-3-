import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/friendPage/friend_page.dart';
import 'package:open_sw/mainPage/groupPage/group_page.dart';
import 'package:open_sw/recommendPage/recommended_places_screen.dart';

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
  @override
  Widget build(BuildContext context) {
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
              GroupPage(userName: '이름이어디까지길어질'), //로그인 할 때 받아오도록 함.
              RecommendedPlacesScreen(),
            ], // 각 탭의 화면
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black,
            //mouseCursor: MouseCursor.defer,
            selectedFontSize: 20,
            selectedIconTheme: IconThemeData(size: 38, color: Colors.black),
            currentIndex: _currentIndex,
            onTap: handleNavTap,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.join_full_outlined),
                label: '친구목록',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_esports),
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
