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
import 'package:open_sw/useful_widget/commonWidgets/custom_dialog.dart';
import 'package:open_sw/useful_widget/commonWidgets/spacing_widgets.dart';
import 'package:open_sw/useful_widget/commonWidgets/text_style_form.dart';

class GroupDetailPageOwner extends StatefulWidget {
  final DocumentSnapshot? group;
  final String? groupId;

  const GroupDetailPageOwner({super.key, this.group, this.groupId});

  @override
  State<GroupDetailPageOwner> createState() => _GroupDetailPageOwnerState();
}

class _GroupDetailPageOwnerState extends State<GroupDetailPageOwner> {
  Map<String, dynamic>? groupData;
  String groupId = '';
  List<Map> memberDetails = [];
  bool isLoading = true;
  Map<String, dynamic>? data;
  DocumentSnapshot? docSnapshot;

  String leaderName = '그룹장2 이름';
  @override
  void initState() {
    super.initState();

    setState(() {
      _loadGroupData();
    });
  }

  void kickout(String uid, String groupId, String name) async {
    // 1. 비동기 작업 먼저 처리

    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayRemove([uid]),
    });
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userSnapshot.exists == false) {
      await FirebaseFirestore.instance
          .collection('tempUsers')
          .doc(uid)
          .delete();
    } else {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'groups': FieldValue.arrayRemove([groupId]),
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to remove $name: $e')));
        }
      }
    }
    // 2. 상태 변경이 필요하면 setState로 감싸기
    if (mounted) {
      setState(() {
        // 예: 목록에서 멤버를 직접 삭제하는 등의 UI 갱신
        //members.remove(uid);  // 예시

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name has been removed from the group.')),
        );
        _loadGroupData();
      });
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
      docSnapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(widget.group!.id)
              .get();
      groupId = widget.group!.id;
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
            print(k);
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
    print(memberDataList);
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
                    InkWell(
                      onTap: () {
                        TextEditingController nameController =
                            TextEditingController(
                              text: groupData!['groupName'] ?? "Group_name",
                            );
                        showCustomAlert(
                          context: context,
                          title: '그룹 이름 편집',
                          message: '변경하실 이름을 입력해주세요',
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(20),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: TextField(
                                  cursorColor: Colors.orangeAccent,
                                  controller: nameController,
                                  style: contentsNormal(),
                                  decoration: const InputDecoration(
                                    hintText: '그룹 이름을 입력해주세요',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                ),
                              ),
                              spacingBox(),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: btn_normal(),
                                      child: Text("취소"),
                                    ),
                                  ),
                                  spacingBox(),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        String newName =
                                            nameController.text.trim();
                                        if (newName.isNotEmpty) {
                                          await FirebaseFirestore.instance
                                              .collection('groups')
                                              .doc(groupId)
                                              .update({'groupName': newName});
                                          setState(() {
                                            groupData!['groupName'] = newName;
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      style: btn_normal(
                                        themeColor: Colors.blueAccent,
                                      ),
                                      child: Text("저장"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "편집",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
              spacingBox(),
              subTitle("예정된 활동"),
              spacingBox(),
              // 활동 카드 리스트
              data!["activities"].length > 0
                  ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 10),
                    itemCount: data!["activities"].length,
                    itemBuilder: (BuildContext context, int index) {
                      var activity = data!["activities"][index];
                      return ActivityCard(
                        date: (activity['date'] as Timestamp)
                            .toDate()
                            .toString()
                            .substring(0, 10),
                        place: activity['place'] ?? "장소 이름",
                      );
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
                  ? MemberSection(
                    title: "그룹원",
                    members: memberDetails,
                    groupId: groupId,
                    onKickout: kickout,
                  )
                  : Column(children: [subTitle('그룹원을 추가하세요'), spacingBox()]),

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
                              groupDocument: docSnapshot,
                            ),
                          );
                        },
                      );

                      setState(() {
                        _loadGroupData();
                      }); // 필요하다면 UI 갱신
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
                        if (memberDetails.isNotEmpty) {
                          showCustomAlert(
                            context: context,
                            title: '삭제 불가',
                            message: '그룹을 삭제하기 전에 모든 그룹원을 내보내야 합니다.',
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: btn_normal(),
                                child: Text('확인'),
                              ),
                            ),
                          );
                        } else {
                          showCustomAlert(
                            context: context,
                            title: '그룹 삭제',
                            message: '정말로 이 그룹을 삭제하시겠습니까?',
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: btn_normal(),
                                    child: Text('취소'),
                                  ),
                                ),
                                spacingBox(),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      final user =
                                          FirebaseAuth.instance.currentUser;

                                      if (groupId.isEmpty) {}
                                      if (user != null && groupId.isNotEmpty) {
                                        // users 컬렉션에서 현재 로그인한 사용자의 문서 참조
                                        final userDocRef = FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(user.uid);

                                        // groups 배열에서 groupId 삭제
                                        await userDocRef.update({
                                          'groups': FieldValue.arrayRemove([
                                            groupId,
                                          ]),
                                        });
                                      } else {
                                        // 예외 처리: 로그인 안 되어 있거나 groupId가 비어있을 때
                                        print('로그인이 필요하거나 groupId가 잘못되었습니다.');
                                      }
                                      await FirebaseFirestore.instance
                                          .collection('groups')
                                          .doc(groupId)
                                          .delete();
                                      Navigator.of(context).pop();
                                      Navigator.of(
                                        context,
                                      ).pop(true); // 이전 페이지로 돌아가기
                                    },
                                    style: btn_normal(themeColor: themeRed),
                                    child: Text('삭제'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }, // 그룹 삭제 로직 추가
                      style: btn_big(themeColor: themeRed, alpha: 0),
                      child: Text("그룹 삭제"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 120),
              bottomNavigationBarSpacer(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 14),
          child: SearchButton(groupId: groupId),
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

class MemberSection extends StatelessWidget {
  final String title;
  final List<Map<dynamic, dynamic>> members;
  final String groupId;
  final void Function(String, String, String) onKickout;

  const MemberSection({
    super.key,
    required this.title,
    required this.members,
    required this.groupId,
    required this.onKickout,
  });

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
            uid: members[index]['uid'] ?? 'member_uid',
            child: TextButton(
              style: btn_small(themeColor: themeRed),
              onPressed: () async {
                //print("닉네임은 : ${members.length}");
                onKickout(
                  members[index]['uid'] ?? 'member_uid',
                  groupId,
                  members[index]['nickName'] ?? 'member_name',
                );
              },
              child: Text('내보내기'),
            ),
          );
        }),
      ],
    );
  }
}

class OwnerSection extends StatelessWidget {
  final String title;
  final List<Map<dynamic, dynamic>> members;

  const OwnerSection({super.key, required this.title, required this.members});

  @override
  Widget build(BuildContext context) {
    //print(members);
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
