import 'package:flutter/material.dart';
import 'utils.dart';
import 'recent_activity.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final String userName = '장영우';
  final int userAge = 22;
  final Gender userGender = Gender.male;

  // 임시 최근활동 내역입니다
  final List<Activity> recentActivities = [
    Activity(type: '활동 이름', place: '활동 장소', date: '2025.05.20'),
    Activity(type: '활동 이름', place: '활동 장소', date: '2025.05.20'),
    Activity(type: '활동 이름', place: '활동 장소', date: '2025.05.20'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 80, left: 26, right: 26),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF2F2F2), Color(0xFFD9D9D9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 사용자 정보
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 사용자 이미지(현재는 검정 container로 대체하였습니다)
                Container(
                  width: 100,
                  height: 100,
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // 사용자 이름
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // 사용자 나이, 성별
                Text(
                  '나이: $userAge  성별: ${userGender.label}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10),
                /*
                // 내 정보 편집 버튼
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0x00ff9933),
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                  ),
                  child: Text('내 정보 편집',
                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                )
                */
              ],
            ),
            SizedBox(height: 40),
            // 최근 활동
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 타이틀
                  Text(
                    '  최근 활동',
                    style: TextStyle(
                      color:Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 10,),
                  // 최근 활동 목록 출력
                  ...List.generate(recentActivities.length, (index) {
                    return ActivityBox(
                      recentAct: recentActivities[index],
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}