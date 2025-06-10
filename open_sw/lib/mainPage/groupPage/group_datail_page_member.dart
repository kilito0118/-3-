import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:open_sw/mainPage/groupPage/groupWidget/friend_plus_at_group_widget.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/member_tile.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/search_button_widget.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

class GroupDatailPageMember extends StatefulWidget {
  final DocumentSnapshot? group;
  final String? groupId;

  const GroupDatailPageMember({super.key, this.group, this.groupId});

  @override
  State<GroupDatailPageMember> createState() => _GroupDatailPageMemberState();
}

class _GroupDatailPageMemberState extends State<GroupDatailPageMember> {
  String groupId = '';

  Map<String, dynamic>? groupData;
  List<Map> memberDetails = [];
  bool isLoading = true;
  Map<String, dynamic>? data;
  DocumentSnapshot? docSnapshot;
  List<DocumentSnapshot> activityDatas = [];
  String leaderEmail = '그룹장 이메일';
  String leaderName = '그룹장 이름';
  @override
  void initState() {
    super.initState();

    rebuild();
  }

  void rebuild() async {
    groupData;
    groupId = '';
    memberDetails = [];
    isLoading = true;
    data = null;
    docSnapshot = null;
    activityDatas = [];
    await _loadGroupData();
    await loadActivities();
    if (mounted) {
      //print(memberDetails);
      setState(() {
        // 상태를 갱신하여 UI를 다시 빌드합니다.
      });
    }
  }

  Future<void> loadActivities() async {
    try {
      final activityIds = (data!['activities'] as List<dynamic>).cast<String>();

      // 병렬 요청 생성
      final futures =
          activityIds
              .map(
                (id) =>
                    FirebaseFirestore.instance
                        .collection('activities')
                        .doc(id)
                        .get(),
              )
              .toList();

      // 모든 요청 동시 실행
      activityDatas = await Future.wait(futures);

      // UI 업데이트
    } catch (e) {
      debugPrint('문서 조회 오류: $e');
    }
  }

  Future<void> getName(String id, int type) async {
    DocumentSnapshot nameSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (nameSnapshot.exists && mounted) {
      if (type == 0) {
        leaderName = nameSnapshot['nickName'] ?? '그룹장 이름';
        leaderEmail = nameSnapshot['email'] ?? '그룹장 이메일';
      } else {
        leaderName = nameSnapshot['nickName'] ?? '그룹원 이름';
      }
    }
  }

  Future<void> _loadGroupData() async {
    if (widget.group != null && widget.group!.exists) {
      groupId = widget.group!.id;
      docSnapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .get();
      data = docSnapshot!.data() as Map<String, dynamic>?;
    } else if (widget.groupId != null) {
      docSnapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(widget.groupId)
              .get();
      groupId = widget.groupId!;
      data = docSnapshot!.data() as Map<String, dynamic>?;
      if (docSnapshot!.exists) {
        data = docSnapshot!.data() as Map<String, dynamic>?;
      }
    }
    if (data != null) {
      getName(data!["leader"], 0);
      List<dynamic> members = data?['members'] ?? [];
      List<Map> details = await fetchMemberDetails(members);
      if (!mounted) return;

      groupData = data;
      memberDetails = details;
      isLoading = false;
    } else {
      groupData = null;
      memberDetails = [];
      isLoading = false;
    }
  }

  Future<List<Map>> fetchMemberDetails(List<dynamic> members) async {
    List<String> memberIds = List<String>.from(members);

    List<Future<DocumentSnapshot>> futures =
        memberIds.map((uid) async {
          final k =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get();

          if (k.exists) {
            return k;
          } else {
            return await FirebaseFirestore.instance
                .collection('tempUsers')
                .doc(uid)
                .get();
          }
        }).toList();
    List<DocumentSnapshot> snapshots = await Future.wait(futures);
    List<Map> memberDataList =
        snapshots.map((snapshot) {
          if (snapshot.exists) {
            return snapshot.data() as Map<String, dynamic>;
          } else {
            return {};
          }
        }).toList();
    // 필터링: uid가 비어있지 않은 멤버만 포함
    memberDataList =
        memberDataList
            .where(
              (member) => member['uid'] != null && member['uid'].isNotEmpty,
            )
            .toList();

    return memberDataList;
  }

  @override
  Widget build(BuildContext context) {
    if (groupData == null || isLoading) {
      return Scaffold(
        backgroundColor: themePageColor,
        body: Center(child: Text('데이터를 불러올 수 없습니다.')),
        floatingActionButton: FloatingActionButton(
          onPressed: _loadGroupData,
          backgroundColor: Colors.white, // 새로고침
          child: Icon(Icons.refresh),
        ),
      );
    }

    return Scaffold(
      backgroundColor: themePageColor,

      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: defaultAppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topAppBarSpacer(context),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    mainTitle(groupData!['groupName'] ?? "Group_name"),
                  ],
                ),
              ),
              spacingBox(),
              subTitle('예정된 활동'),
              spacingBox(),

              activityDatas.isNotEmpty
                  ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 10),
                    itemCount: data!["activities"].length,
                    itemBuilder: (BuildContext context, int index) {
                      if (activityDatas[index].exists) {
                        var activityData =
                            activityDatas[index].data() as Map<String, dynamic>;
                        return ActivityCard(
                          date: (activityData['date'] as Timestamp)
                              .toDate()
                              .toString()
                              .substring(0, 10),
                          place: activityData['place']['name'] ?? "장소 이름",
                        );
                      } else {
                        return Text("활동 데이터를 불러올 수 없습니다.");
                      }
                    },
                  )
                  : contentsBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_busy,
                          size: 60,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: paddingBig),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('예정된 활동이 없어요', style: contentsBig()),
                            Text('활동 검색을 통해 일정을 추가해보세요', style: contentsDetail),
                          ],
                        ),
                      ],
                    ),
                  ),

              spacingBox(),

              OwnerSection(
                title: "그룹장",
                members: [
                  {
                    'nickName': leaderName,
                    'uid': data!['leader'] ?? '그룹장 UID',
                    'email': leaderEmail,
                  },
                ],
              ),

              memberDetails.isNotEmpty
                  ? MemberSection(title: "그룹원", members: memberDetails)
                  : Column(children: [subTitle('그룹원을 추가하세요'), spacingBox()]),
              // MemberSection(title: "그룹원", members: memberNames),
              Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.transparent,
                        builder: (context) {
                          return SizedBox(
                            height: 200,
                            child: FriendPlusAtGroupWidget(
                              logic: rebuild,
                              groupDocument: docSnapshot,
                            ),
                          );
                        },
                      );
                      setState(() {
                        _loadGroupData();
                      });
                    },
                    style: btnBig(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('그룹원 추가하기'),
                        spacingBoxMini(),
                        Icon(Icons.add),
                      ],
                    ),
                  ),

                  spacingBox(),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        final currentUserUid =
                            FirebaseAuth.instance.currentUser?.uid;

                        if (groupData != null &&
                            groupData!['members'] != null) {
                          List<dynamic> members = List<dynamic>.from(
                            groupData!['members'],
                          );
                          if (members.contains(currentUserUid)) {
                            members.remove(currentUserUid);

                            FirebaseFirestore.instance
                                .collection('groups')
                                .doc(groupId)
                                .update({'members': members});
                          }
                        }

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUserUid)
                            .update({
                              'groups': FieldValue.arrayRemove([groupId]),
                            });

                        Navigator.pop(context); // Optionally navigate back
                      },
                      style: btnBig(
                        themeColor: themeRed,
                        alpha: 0,
                      ), // 그룹 나가기 로직 추가
                      child: Text("그룹 나가기"),
                    ),
                  ),
                  SizedBox(height: 120),
                  bottomNavigationBarSpacer(context),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: SearchButton(groupId: docSnapshot!.id, logic: rebuild),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String date;
  final String place;

  const ActivityCard({super.key, required this.date, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        title: Text(
          date,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(place, style: TextStyle(color: Colors.white)),
        //trailing: Icon(Icons.more_vert, color: Colors.white),
      ),
    );
  }
}

// class MemberSection extends StatelessWidget {
//   final String title;
//   final List<Map<dynamic, dynamic>> members;

//   const MemberSection({super.key, required this.title, required this.members});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//         ListView.builder(
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: members.length,
//           itemBuilder: (context, index) {
//             return MemberTile(
//               name: members[index]['nickName'] ?? 'member_name',
//               uid: members[index]['uid'] ?? 'member_uid',
//             );
//           },
//         ),
//         SizedBox(height: 10),
//       ],
//     );
//   }
// }

// class MemberTile extends StatelessWidget {
//   final String name;
//   final String uid;
//   const MemberTile({super.key, required this.name, required this.uid});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       color: Colors.white,
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: Color(uid.hashCode % 0xFFFFFF).withOpacity(1.0),
//         ),
//         title: Text(name),
//       ),
//     );
//   }
// }

class OwnerSection extends StatelessWidget {
  final String title;
  final List<Map<dynamic, dynamic>> members;

  const OwnerSection({super.key, required this.title, required this.members});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle(title),
        spacingBox(),
        ...List.generate(members.length, (index) {
          return memberTile(
            name: members[index]['nickName'] ?? 'member_name',
            email: members[index]['email'] ?? 'member_email',
            uid: members[index]["uid"] ?? "",
            child: Icon(Icons.star, color: themeYellow, size: 28),
          );
        }),
      ],
    );
  }
}

class MemberSection extends StatefulWidget {
  final String title;
  final List<Map<dynamic, dynamic>> members;

  const MemberSection({super.key, required this.title, required this.members});

  @override
  State<MemberSection> createState() => _MemberSectionState();
}

class _MemberSectionState extends State<MemberSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        subTitle(widget.title),
        spacingBox(),
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.members.length,
          itemBuilder: (context, index) {
            return memberTile(
              name: widget.members[index]['nickName'] ?? 'member_name',
              email: widget.members[index]['email'] ?? 'member_email',
              uid: widget.members[index]['uid'] ?? 'member_uid',
              child: Text(""),
            );
          },
        ),
      ],
    );
  }
}
