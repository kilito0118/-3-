import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
}

class GroupTileWidget extends StatelessWidget {
  final DocumentSnapshot group;
  const GroupTileWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? data;
    if (group.exists) {
      data = group.data() as Map<String, dynamic>?;
      if (data == null) {
        return Text("");
      }

      // 활동 정보 리스트
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print(1);
          },
          child: Container(
            height: 80,
            margin: EdgeInsets.only(right: 8), // 아이콘과 간격
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 그룹 프로필 (지금은 그냥 이름 첫글자로 해둠)
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              /*
                            child: SizedBox(
                              width: 40,
                              height: 40,*/
                              child: Text(
                                data!["groupName"][0],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            SizedBox(width: 10),

                            // 친구 이름
                            Text(
                              group["groupName"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10), // tile별 거리 확보
      ],
    );
  }
}
