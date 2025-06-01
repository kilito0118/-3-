import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/groupPage/group_detail_page_owner.dart';

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

  const GroupTileWidget({super.key, required this.group});

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailPage(group: widget.group),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
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
                SizedBox(width: 10),
                // 그룹 정보
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 그룹 이름
                    Text(
                      data["groupName"],
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    // 그룹장 이름
                    Text(
                      "$leaderName 님의 그룹",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // 다음 타일과 거리두기
        SizedBox(height: 10),
      ],
    );
  }
}
