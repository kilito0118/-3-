import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:open_sw/mainPage/groupPage/group_detail_page.dart';
import 'package:open_sw/mainPage/groupPage/regist_group.dart';

class GroupPlusTileWidget extends StatelessWidget {
  const GroupPlusTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => Center(child: CircularProgressIndicator()),
            );

            try {
              String groupId = await registGroup();
              await FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupId)
                  .get(GetOptions(source: Source.server));

              Navigator.pop(context); // 로딩 창 닫기

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailPage(groupId: groupId),
                ),
              );
            } catch (e) {
              Navigator.pop(context);
              print(e);
            }
          },
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(20),
              dashPattern: [10, 5],
              strokeWidth: 2,
              color: Color(0xff585858),
              padding: EdgeInsets.all(16),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "새 그룹 추가하기",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff585858),
                          fontWeight: FontWeight.w500,
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
