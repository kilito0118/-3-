import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/services/activity_info.dart';

class Activity {
  final int type;
  final Map<String, String> place;
  final DateTime date;
  final String groupId;
  final List<dynamic> score; //1~9?
  final List<dynamic> userId;

  Activity({
    required this.type,
    required this.place,
    required this.date,
    required this.groupId,
    required this.score,
    required this.userId,
  });
}

class ActivityBox extends StatefulWidget {
  final Activity recentAct;
  final String actId; // 그룹 ID가 필요할 경우 추가

  const ActivityBox({super.key, required this.recentAct, required this.actId});

  @override
  State<ActivityBox> createState() => _ActivityBoxState();
}

class _ActivityBoxState extends State<ActivityBox> {
  bool liked = false;
  bool disliked = false;

  // 좋아요 버튼을 눌렀을 때 실행되는 함수입니다
  Future<void> like() async {
    liked = !liked;
    if (liked) {
      disliked = false;
      DocumentSnapshot activityData =
          await FirebaseFirestore.instance
              .collection('activities')
              .doc(widget.actId)
              .get();
      List<int> scores = List<int>.from(activityData['score']);
      scores[userIndex] = 9; // 좋아요를 누르면 9, 아니면 1로 설정
      FirebaseFirestore.instance
          .collection('activities')
          .doc(widget.actId)
          .update({'score': scores});
    }

    // actId를 사용하여 Firebase에서 score를 변경
  }

  // 싫어요 버튼을 눌렀을 때 실행되는 함수입니다
  void dislike() async {
    disliked = !disliked;
    if (disliked) {
      liked = false;
      DocumentSnapshot activityData =
          await FirebaseFirestore.instance
              .collection('activities')
              .doc(widget.actId)
              .get();
      List<int> scores = List<int>.from(activityData['score']);
      scores[userIndex] = 1; // 좋아요를 누르면 9, 아니면 1로 설정
      FirebaseFirestore.instance
          .collection('activities')
          .doc(widget.actId)
          .update({'score': scores});
    }
  }

  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  int userIndex = -1;

  @override
  void initState() {
    // userId 배열에서 현재 사용자의 인덱스를 찾습니다.
    userIndex = widget.recentAct.userId.indexOf(currentUserId);

    // 해당 인덱스의 score 값을 가져옵니다.
    int userScore = widget.recentAct.score[userIndex];
    setState(() {
      if (userScore > 4) {
        like();
      } else if (userScore < 4) {
        dislike();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 활동 일자
          Text(
            "${widget.recentAct.date.year}-${widget.recentAct.date.month.toString().padLeft(2, '0')}-${widget.recentAct.date.day.toString().padLeft(2, '0')}",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 10),

          // 활동 이름 및 장소
          Container(
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 활동명
                    Text(
                      activityList[widget.recentAct.type]['name'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // 활동 장소
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.recentAct.place['name'] ?? "장소 정보 없음",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // 활동 평가
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 싫어요 버튼
              TextButton(
                onPressed: () {
                  setState(() {
                    dislike();
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF6283E9),
                  padding: EdgeInsets.all(0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      disliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                      size: 32,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '나빴어요',
                      style: TextStyle(
                        color: const Color(0xFF6283E9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // 좋아요 버튼
              TextButton(
                onPressed: () {
                  setState(() {
                    like();
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFFE75F5F),
                  padding: EdgeInsets.all(0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '좋았어요',
                      style: TextStyle(
                        color: const Color(0xFFE75F5F),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      liked ? Icons.favorite : Icons.favorite_outline,
                      size: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
