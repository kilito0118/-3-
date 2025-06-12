import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:open_sw/utils/open_url.dart';
import 'package:open_sw/utils/time_to_text.dart';
import 'recent_activity.dart';

class UpcomingActivityTile extends StatefulWidget {
  final Activity recentAct;
  final String actId; // 그룹 ID가 필요할 경우 추가
  final int type; //1이면 X 안보이게(1이면 마이페이지임)
  final void Function() logic;

  const UpcomingActivityTile({
    super.key,
    required this.recentAct,
    required this.type,
    required this.actId,
    required this.logic,
  });

  @override
  State<UpcomingActivityTile> createState() => _UpcomingActivityTileState();
}

class _UpcomingActivityTileState extends State<UpcomingActivityTile> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> removeActivityFromGroupMembers() async {
    try {
      final groupInfo = await fetchGroupInfo(widget.recentAct.groupId);
      if (groupInfo == null || groupInfo['members'] == null) {
        throw Exception('Group information or members not found');
      }
      await removeActivityFromMember(groupInfo['leader'], widget.actId);
      for (final memberId in groupInfo['members']) {
        await removeActivityFromMember(memberId, widget.actId);
      }
      groupInfo["activities"] = List.from(groupInfo['activities'] ?? [])
        ..remove(widget.actId);
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.recentAct.groupId)
          .update({'activities': groupInfo['activities']});
    } catch (e) {
      debugPrint('Error removing activity from group members: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchGroupInfo(String groupId) async {
    try {
      final groupDoc =
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .get();

      if (groupDoc.exists) {
        return groupDoc.data() as Map<String, dynamic>;
      } else {
        debugPrint('Group document not found for groupId: $groupId');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching group info: $e');
      return null;
    }
  }

  Future<void> removeActivityFromMember(String memberId, String actId) async {
    try {
      final memberDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(memberId)
              .get();

      if (memberDoc.exists) {
        final memberData = memberDoc.data() as Map<String, dynamic>;
        final activities = List.from(memberData['activities'] ?? []);
        activities.removeWhere((activity) => activity == actId);
        //print('Removing activity $actId from member $memberId,$actId');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(memberId)
            .update({'activities': activities});
      } else {
        debugPrint('Member document not found for memberId: $memberId');
      }
    } catch (e) {
      debugPrint('Error removing activity from member: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: paddingSmall, bottom: 14),
              width: 320,
              padding: EdgeInsets.symmetric(
                horizontal: paddingBig,
                vertical: paddingMid,
              ),
              decoration: BoxDecoration(
                gradient: themeGradient(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: themeLightOrange.withAlpha(140),
                    blurRadius: 8,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeToText(widget.recentAct.date),
                          style: contentsDetailWhite,
                        ),
                        Text(
                          '${widget.recentAct.date.hour.toString().padLeft(2, '0')}시 ${widget.recentAct.date.minute.toString().padLeft(2, '0')}분',
                          style: contentsDetailWhite,
                        ),
                        spacingBoxMini(),
                        Text(
                          widget.recentAct.place['name'] ?? '장소정보 없음',
                          style: contentsBig(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                  //지도 열기 버튼을 약간 아래로 하기 위한 부분
                  //TODO: 이 부분은 나중에 더 좋은 방법으로 개선할 수 있음
                  Column(
                    children: [
                      SizedBox(height: 30),
                      TextButton(
                        onPressed: () {
                          final url =
                              "https://place.map.kakao.com/${widget.recentAct.place['id']}";
                          openUrl(url);
                        },
                        style: btnSmall(themeColor: Colors.white),
                        child: Text('지도열기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            spacingBox(),
          ],
        ),
        widget.type == 1
            ? SizedBox.shrink()
            : Positioned(
              right: 10,
              top: 4,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  showCustomAlert(
                    context: context,
                    title: '일정 삭제',
                    message: '정말로 이 일정을 삭제하시겠습니까?\n 그룹 모두에게 적용됩니다.',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: btnNormal(),
                            child: Text('취소'),
                          ),
                        ),
                        spacingBox(),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              await removeActivityFromGroupMembers();
                              await FirebaseFirestore.instance
                                  .collection('activities')
                                  .doc(widget.actId)
                                  .delete();
                              widget.logic();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('일정이 삭제되었습니다.')),
                                );
                              }
                              widget.logic();
                            },
                            style: btnNormal(themeColor: themeRed),
                            child: Text('삭제'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }
}
