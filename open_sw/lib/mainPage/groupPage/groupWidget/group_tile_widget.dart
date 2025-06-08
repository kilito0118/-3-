import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/groupPage/group_datail_page_member.dart';
import 'package:open_sw/mainPage/groupPage/group_detail_page_owner.dart';

import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

/*
class Group {
  String name;
  String leader;
  String id;
  List<String> members;
  int memberCount;
  Group({
    required this.id,
    required this.name,
    required this.leader,
    required this.members,
    required this.memberCount,
  });
}*/

class GroupTileWidget extends StatefulWidget {
  final DocumentSnapshot group;
  final VoidCallback onTap; // 선택적으로 탭 이벤트 핸들러 추가

  const GroupTileWidget({super.key, required this.group, required this.onTap});

  @override
  State<GroupTileWidget> createState() => _GroupTileWidgetState();
}

class _GroupTileWidgetState extends State<GroupTileWidget> {
  String leaderName = "그룹장"; // 기본 그룹장 이름

  @override
  void initState() {
    super.initState();
    fetchLeaderName();
  }

  // DB에서 그룹장 이름 반환
  Future<void> fetchLeaderName() async {
    final data = widget.group.data() as Map<String, dynamic>;
    final leaderUid = data["leader"];

    try {
      final leaderDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(leaderUid)
              .get();

      if (leaderDoc.exists) {
        setState(() {
          leaderName = leaderDoc["nickName"] ?? "그룹장";
        });
      }
    } catch (e) {
      print("그룹장 정보 불러오기 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.group.data() as Map<String, dynamic>;

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            widget.onTap(); // 탭 이벤트 핸들러 호출
            final user = FirebaseAuth.instance.currentUser;
            if (user != null && user.uid == widget.group["leader"]) {
              // 그룹장이면 그룹 상세 페이지로 이동
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => GroupDetailPageOwner(group: widget.group),
                ),
              );
              widget.onTap();
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => GroupDatailPageMember(group: widget.group),
                ),
              );
            }
            widget.onTap();
          },
          child: ContentsBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 그룹 프로필 사진
                // 현재는 그룹명 첫글자 표시로 대체
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.orangeAccent,
                  child: Text(
                    data["groupName"][0], // 첫 글자 표시
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                spacingBox(),
                // 그룹 정보
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 그룹 이름
                    Text(
                      data["groupName"],
                      style: contentsBig(fontWeight: FontWeight.bold),
                    ),
                    // 그룹장 이름
                    Text(
                      "$leaderName 님의 그룹",
                      style: contentsDetail,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // 다음 타일과 거리두기
        SizedBox(height: 14),
      ],
    );
  }
}
