import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:open_sw/mainPage/groupPage/groupWidget/friend_plus_at_group_widget.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/member_tile.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/search_button_widget.dart';

import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

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
      // 예: 목록에서 멤버를 직접 삭제하는 등의 UI 갱신
      //members.remove(uid);  // 예시

      rebuild();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name has been removed from the group.')),
      );
    }
  }

  Future<void> getName(String id, int type) async {
    DocumentSnapshot nameSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (nameSnapshot.exists && mounted) {
      if (type == 0) {
        leaderName = nameSnapshot['nickName'] ?? '그룹장1 이름';
        leaderEmail = nameSnapshot['email'] ?? '그룹장1 이메일';
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
          onPressed: rebuild, // 새로고침
          backgroundColor: Colors.white,
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
                                      style: btnNormal(),
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
                                        if (mounted) {
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      style: btnNormal(
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
                              logic: rebuild,
                              groupDocument: docSnapshot,
                            ),
                          );
                        },
                      );

                      rebuild();
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
                                style: btnNormal(),
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
                                    style: btnNormal(),
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
                                        debugPrint(
                                          '로그인이 필요하거나 groupId가 잘못되었습니다.',
                                        );
                                      }
                                      await FirebaseFirestore.instance
                                          .collection('groups')
                                          .doc(groupId)
                                          .delete();
                                      if (mounted) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        Navigator.of(
                                          // ignore: use_build_context_synchronously
                                          context,
                                        ).pop(true); // 이전 페이지로 돌아가기
                                      }
                                      rebuild();
                                    },
                                    style: btnNormal(themeColor: themeRed),
                                    child: Text('삭제'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }, // 그룹 삭제 로직 추가
                      style: btnBig(themeColor: themeRed, alpha: 0),
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
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: SearchButton(groupId: groupId, logic: rebuild),
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

class MemberSection extends StatefulWidget {
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
  State<MemberSection> createState() => _MemberSectionState();
}

class _MemberSectionState extends State<MemberSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              uid: widget.members[index]['uid'] ?? 'member_uid',
              email: widget.members[index]['email'] ?? 'member_email',
              child: TextButton(
                style: btnSmall(themeColor: themeRed),
                onPressed: () {
                  widget.onKickout(
                    widget.members[index]['uid'] ?? 'member_uid',
                    widget.groupId,
                    widget.members[index]['nickName'] ?? 'member_name',
                  );
                  setState(() {});
                },
                child: Text('내보내기'),
              ),
            );
          },
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitle(title),
        spacingBox(),
        ...List.generate(members.length, (index) {
          return memberTile(
            email: members[index]['email'] ?? 'member_email',
            name: members[index]['nickName'] ?? 'member_name',
            uid: members[index]["uid"] ?? "",
            child: Icon(Icons.star, color: themeYellow, size: 28),
          );
        }),
      ],
    );
  }
}
