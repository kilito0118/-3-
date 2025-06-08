import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/friend_plus_at_group_widget.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/member_tile.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/search_button_widget.dart';
import 'package:open_sw/useful_widget/commonWidgets/app_bar_widgets.dart';
import 'package:open_sw/useful_widget/commonWidgets/boxes_styles.dart';
import 'package:open_sw/useful_widget/commonWidgets/buttons_styles.dart';
import 'package:open_sw/useful_widget/commonWidgets/colors/theme_colors.dart';
import 'package:open_sw/useful_widget/commonWidgets/spacing_widgets.dart';
import 'package:open_sw/useful_widget/commonWidgets/text_style_form.dart';

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

  String leaderName = '그룹장2 이름';
  @override
  void initState() {
    super.initState();

    setState(() {
      _loadGroupData();
      loadActivities();
    });
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
      if (mounted) setState(() {});
    } catch (e) {
      print('문서 조회 오류: $e');
    }
  }

  Future<void> getName(String id, int type) async {
    DocumentSnapshot nameSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (nameSnapshot.exists) {
      if (type == 0) {
        setState(() {
          leaderName = nameSnapshot['nickName'] ?? '그룹장1 이름';
        });
      } else {
        setState(() {
          leaderName = nameSnapshot['nickName'] ?? '그룹원 이름';
        });
      }
    }
  }

  Future<void> _loadGroupData() async {
    if (widget.group != null && widget.group!.exists) {
      data = widget.group!.data() as Map<String, dynamic>?;
      groupId = widget.group!.id;
      docSnapshot = widget.group;
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
      setState(() {
        groupData = data;
        memberDetails = details;
        isLoading = false;
      });
    } else {
      setState(() {
        groupData = null;
        memberDetails = [];
        isLoading = false;
      });
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
            return FirebaseFirestore.instance
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

    return memberDataList;
  }

  @override
  Widget build(BuildContext context) {
    if (groupData == null || isLoading) {
      return Scaffold(
        body: Center(child: Text('데이터를 불러올 수 없습니다.')),
        floatingActionButton: FloatingActionButton(
          onPressed: _loadGroupData, // 새로고침
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
          padding: const EdgeInsets.symmetric(horizontal: 14),
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
                  : ContentsBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 65,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: 20),
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
                  {'nickName': leaderName, 'uid': data!['leader'] ?? '그룹장 UID'},
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
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        barrierColor: Colors.transparent,
                        builder: (context) {
                          return SizedBox(
                            height: 200,
                            child: FriendPlusAtGroupWidget(
                              groupDocument: docSnapshot,
                            ),
                          );
                        },
                      );
                      setState(() {
                        _loadGroupData();
                      });
                    },
                    style: btn_big(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('그룹원 추가하기'),
                        spacingBox_mini(),
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
                      }, // 그룹 나가기 로직 추가
                      child: Text(
                        "그룹 나가기",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 120),
                  bottomNavigationBarSpacer(context),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 14),
          child: SearchButton(groupId: docSnapshot!.id),
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
        trailing: Icon(Icons.more_vert, color: Colors.white),
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
            uid: members[index]["uid"] ?? "",
            child: Icon(Icons.star, color: themeYellow, size: 28),
          );
        }),
      ],
    );
  }
}

class MemberSection extends StatelessWidget {
  final String title;
  final List<Map<dynamic, dynamic>> members;

  const MemberSection({super.key, required this.title, required this.members});

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
            uid: members[index]["uid"] ?? "",
            child: Text(''),
          );
        }),
      ],
    );
  }
}
