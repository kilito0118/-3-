import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_sw/login/login_screen.dart';

import '../useful_widget/commonWidgets/common_widgets.dart';
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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: padding_small),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Center(
              child: Column(
                children: [
                  spacingBox(),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(
                      uid.hashCode % 0xFFFFFF,
                    ).withAlpha(255),
                    child: Text(
                      widget.name[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  mainTitle(widget.name),
                  spacingBoxMini(),
                  Text(
                    '나이: ${widget.age}  성별: ${widget.gender}',
                    style: contentsNormal(),
                  ),
                  spacingBox(),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.email));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('이메일이 클립보드에 복사되었습니다.')),
                      );
                    },
                    style: btnBig(),
                    child: Text('이메일: ${widget.email}'),
                  )
                ],
              ),
            ),
            spacingBox(),
            subTitle('최근 활동'),
            recentActivities.isEmpty
                ? Column(
              children: [
                spacingBox(),
                contentsBox(
                    child: Row(
                      children: [
                        Icon(Icons.history_toggle_off, size: 60, color: Colors.grey,),
                        SizedBox(width: padding_big,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('최근 활동 내역이 없어요.',style: contentsBig(),),
                            spacingBoxMini(),
                            Text('그룹에서 한 활동들이 이곳에 추가돼요', style: contentsDetail,),
                          ],
                        )
                      ],
                    )
                ),
                spacingBox()
              ],
            )
                : spacingBox(),
            ...List.generate(recentActivities.length, (index) {
              return ActivityBox(
                  recentAct: recentActivities[index],
                  actId: recentActivityIds[index]
              );
            }),
            spacingBox(),
            Center(
              child: TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                        (Route<dynamic> route) => false,
                  );
                },
                style: btnTransparent(themeColor: themeRed),
                child: Text('로그아웃'),
              ),
            ),
            SafeArea(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
