import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/friend_plus_widget.dart';
import 'friend_tile.dart';

class FriendPage extends StatelessWidget {
  final List<Friend> friends = [
    // 친구 목록 예시 데이터 (나중에 DB에서 받아오기)
    Friend(name: '오정인'),
    Friend(name: '장영우'),
    Friend(name: '박준혁'),
    Friend(name: '허영호'),
    Friend(name: '이진용'),
  ];

  FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 배경색 설정
      appBar: PreferredSize(
        // '친구' 부분 (appbar)
        preferredSize: Size.fromHeight(130),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Text(
                '친구',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        // 친구 추가 버튼 + 친구 목록 (body)
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 친구 추가 버튼
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromRGBO(255, 152, 49, 1),
                      const Color.fromRGBO(255, 104, 2, 1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 203, 144, 55),
                      spreadRadius: 1,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    '친구 추가하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.transparent,

                      builder: (context) {
                        return SizedBox(height: 200, child: FriendPlusWidget());
                        // 원하는 위젯 추가
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 40),
            // 친구 목록
            Text(
              '내 친구',
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            // 친구 목록 출력 (friend_tile.dart에 자세한 코드 있음)
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return FriendTile(friend: friends[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
