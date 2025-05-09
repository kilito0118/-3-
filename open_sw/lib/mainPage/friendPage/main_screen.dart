import 'package:flutter/material.dart';
//import 'package:open_sw/naver_directions_button.dart';
import 'friend_page.dart';
import 'group_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [GroupScreen(), FriendPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // 네비게이션바 (대충 구현함)
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: '그룹'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '친구'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
