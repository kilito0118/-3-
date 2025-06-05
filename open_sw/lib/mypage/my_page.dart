import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/login/login_screen.dart';

import 'recent_activity.dart';

class MyPage extends StatefulWidget {
  final String name;
  final int age;
  final String gender;
  const MyPage({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
  });

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  DocumentSnapshot? userInfo;
  List<dynamic> recentActivities = [];
  Map<String, dynamic>? userData;

  Future<void> loadActivities() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (doc.exists) {
        userData = doc.data() as Map<String, dynamic>;
        if (userData != null) {
          if (userData!.containsKey('activities')) {
            recentActivities = (userData!['activities'] as List<dynamic>);
          } else {
            userData!['activities'] = [];
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'activities': []});
          }
        }
      }
      setState(() {});
    } on FirebaseException catch (e) {
      debugPrint('Firestore Error: ${e.code}');
    }
  }

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

  //final String userName = '장영우';
  //final int userAge = 22;
  //final Gender userGender = Gender.male;

  // 임시 최근활동 내역입니다
  /*
  final List<Activity> recentActivities = [
    Activity(type: '활동 이름', place: '활동 장소', date: '2025.05.20'),
    Activity(type: '활동 이름', place: '활동 장소', date: '2025.05.20'),
    Activity(type: '활동 이름', place: '활동 장소', date: '2025.05.20'),
    Activity(type: '활동 이름', place: '활동 장소', date: '2025.05.20'),
    Activity(type: '활동 이름', place: '활동 장소', date: '2025.05.20'),
  ];*/

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF2F2F2), Color(0xFFD9D9D9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 26, right: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 사용자 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: Text("로그아웃"),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
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
                    widget.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // 사용자 나이, 성별
                  Text(
                    '나이: ${widget.age}  성별: ${widget.gender}',
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
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 타이틀
                    Text(
                      '  최근 활동',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 10),
                    // 최근 활동 목록 출력
                    ...List.generate(recentActivities.length, (index) {
                      return ActivityBox(recentAct: recentActivities[index]);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
