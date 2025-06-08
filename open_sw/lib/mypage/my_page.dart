import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_sw/login/login_screen.dart';
import 'package:open_sw/recommendPlacePage/regist_activity.dart';

import 'recent_activity.dart';

class MyPage extends StatefulWidget {
  final String name;
  final int age;
  final String gender;
  final String email;
  const MyPage({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
  });

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  DocumentSnapshot? userInfo;
  List<dynamic> recentActivities = [];
  List<dynamic> recentActivityIds = [];
  Map<String, dynamic>? userData;

  Future<void> loadActivities() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    //debugPrint('Recent Activities: $recentActivities');
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
            recentActivityIds = (userData!['activities']);
          } else {
            userData!['activities'] = [];
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'activities': []});
          }
          for (String activityId in recentActivityIds) {
            final activityDoc =
                await FirebaseFirestore.instance
                    .collection('activities')
                    .doc(activityId)
                    .get();

            if (activityDoc.exists) {
              final activityData = activityDoc.data() as Map<String, dynamic>;
              //이거까지 하면 recentActivities에 Map<String, dynamic> 형태로 저장됩니다
              //여기서 Activity 형태로 변환
              recentActivities.add(
                Activity(
                  type: activityData['type'] ?? '활동 이름',
                  place: (activityData['place'] as Map<String, dynamic>)
                      .map<String, String>(
                        (key, value) => MapEntry(key, value.toString()),
                      ),
                  date:
                      activityData['date'] != null &&
                              activityData['date'] is Timestamp
                          ? (activityData['date'] as Timestamp).toDate()
                          : DateTime.now(),

                  groupId: activityData['groupId'] ?? '그룹 ID 없음',
                  score: activityData['score'] ?? 0,
                  userId: activityData['userId'] ?? '사용자 ID 없음',
                ),
              );
              /*
              recentActivities =
                  recentActivities.map((data) {
                    return Activity(
                      type: data['type'] ?? '활동 이름',
                      place: {
                        'id': '',
                        'name': '',
                        'address': '',
                        'phone': '',
                        'x': '',
                        'y': '',
                      }, //이 부분을 그냥 받아온 Map<String, String> 형태로 넣어주시면 됩니다,
                      date:
                          data['date'] != null && data['date'] is Timestamp
                              ? (data['date'] as Timestamp).toDate().toString()
                              : '날짜 없음',
                      groupId: data['groupId'] ?? '그룹 ID 없음',
                      score: data['score'] ?? 0,
                      userId: data['userId'] ?? '사용자 ID 없음',
                    );
                  }).toList();*/
            }
          }
          debugPrint('Recent Activities: $recentActivities');
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

  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    uid = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
    setState(() {
      _loadUserData();
      loadActivities();
    });
  }

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
                    child: CircleAvatar(
                      backgroundColor: Color(
                        uid.hashCode % 0xFFFFFF,
                      ).withOpacity(1.0), // 이름 해시값으로 색상 생성
                      child: Text(
                        widget.name[0],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
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
                  // 사용자 이메일
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.email));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('이메일이 클립보드에 복사되었습니다.')),
                      );
                    },
                    child: Text(
                      '이메일: ${widget.email}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
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
                    recentActivities.isEmpty
                        ? Text(
                          '최근 활동이 없습니다.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                        : Container(
                          height: 700,
                          child:
                              ListView.builder(
                                //shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: recentActivities.length,
                                itemBuilder: (context, index) {
                                  return ActivityBox(
                                    recentAct: recentActivities[index],
                                    actId: recentActivityIds[index],
                                  );
                                },
                              ) ??
                              Text(""),
                        ),
                    TextButton(
                      onPressed: () {
                        Activity act = Activity(
                          date: DateTime.now(),
                          groupId: 'group1',
                          place: {
                            'id': '',
                            'name': '',
                            'address': '',
                            'phone': '',
                            'x': '',
                            'y': '',
                          }, //이 부분을 그냥 받아온 Map<String, String> 형태로 넣어주시면 됩니다
                          score: [5],
                          type: 0,
                          userId: [FirebaseAuth.instance.currentUser!.uid],
                        );
                        registActivity(act);
                        //print(act);
                      },
                      child: Text("더보기"),
                    ),
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
