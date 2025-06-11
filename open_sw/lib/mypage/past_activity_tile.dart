import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/services/activity_info.dart';
import 'package:open_sw/services/category_info.dart';
import 'package:open_sw/useful_widget/commonWidgets/boxes_styles.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:open_sw/useful_widget/commonWidgets/spacing_widgets.dart';
import 'package:open_sw/utils/open_url.dart';
import 'package:open_sw/utils/time_to_text.dart';
import 'recent_activity.dart';

class PastActivityTile extends StatefulWidget {
  final Activity recentAct;
  final String actId; // 그룹 ID가 필요할 경우 추가

  const PastActivityTile({super.key, required this.recentAct, required this.actId});

  @override
  State<PastActivityTile> createState() => _PastActivityTileState();
}

class _PastActivityTileState extends State<PastActivityTile> {
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
      scores[userIndex] = 7; // 좋아요를 누르면 9, 아니면 1로 설정
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
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: paddingSmall, bottom: 14),
          width: 300,
          padding: EdgeInsets.symmetric(horizontal: paddingBig, vertical: paddingMid),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: Offset(0, 6)
              )
            ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  getPrimeIcon(widget.recentAct.type, 60),
                  SizedBox(width: paddingBig,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activityList[widget.recentAct.type]['name'],
                          style: contentsDetail,
                        ),
                        Text(
                          widget.recentAct.place['name'] ?? '장소정보 없음',
                          style: contentsTitle(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  spacingBoxDevider(),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              dislike();
                            });
                          },
                          style: btnSmall(
                            themeColor: disliked ? Colors.blueAccent : Colors.grey
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                disliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                                size: 18,
                              ),
                              Text('  나빴어요'),
                            ],
                          ),
                        ),
                      ),
                      spacingBox(),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              like();
                            });
                          },
                          style: btnSmall(
                            themeColor: liked ? themeRed : Colors.grey
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                liked ? Icons.favorite : Icons.favorite_outline,
                                size: 18,
                              ),
                              Text('  좋았어요'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          )
        ),
        spacingBox(),
      ],
    );
  }
}
