import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/friend_plus_at_group_widget.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/search_button_widget.dart';

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

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'groups': FieldValue.arrayRemove([groupId]),
      });

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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to remove $name: $e')));
      }
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
        memberIds.map((uid) {
          return FirebaseFirestore.instance.collection('users').doc(uid).get();
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text("그룹 페이지", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      groupData!['groupName'] ?? "Group_name",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController nameController =
                                TextEditingController(
                                  text: groupData!['groupName'] ?? "Group_name",
                                );
                            return AlertDialog(
                              title: Text("그룹 이름 편집"),
                              content: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: "그룹 이름",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("취소"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    String newName = nameController.text.trim();
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
                                  child: Text("저장"),
                                ),
                              ],
                            );
                          },
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
              SizedBox(height: 20),
              Text(
                "예정된 활동",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
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
                        date: activity['date'] ?? "00.00(화)",
                        place: activity['place'] ?? "장소 이름",
                      );
                    },
                  )
                  : Text("예정된 활동이 없습니다."),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: 0,
                itemBuilder: (BuildContext context, int index) {
                  return ActivityCard(date: "00.00(화)", place: "장소 이름");
                },
              ),

              SizedBox(height: 20),
              OwnerSection(
                title: "그룹장",
                members: [
                  {'nickName': leaderName},
                ],
              ),

              memberDetails.isNotEmpty
                  ? MemberSection(
                    title: "그룹원",
                    members: memberDetails,
                    groupId: groupId,
                    onKickout:
                        () => kickout(
                          memberDetails[0]['uid'] ?? 'uid',
                          groupId,
                          memberDetails[0]['nickName'] ?? '그룹원 이름',
                        ),
                  )
                  : Text(""),

              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
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
                                  "그룹원 추가하기",
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
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // 그룹 삭제 로직 추가
                      showDialog(
                        context: context,
                        builder: (context) {
                          //print(groupId);
                          if (memberDetails.isNotEmpty) {
                            return AlertDialog(
                              title: Text("그룹 삭제"),
                              content: Text("그룹을 삭제하기 전에 모든 그룹원을 내보내야 합니다."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("확인"),
                                ),
                              ],
                            );
                          }
                          return AlertDialog(
                            title: Text("그룹 삭제"),
                            content: Text("정말로 이 그룹을 삭제하시겠습니까?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("취소"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  print(groupId);
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
                                child: Text("삭제"),
                              ),
                            ],
                          );
                        },
                      );
                    }, // 그룹 삭제 로직 추가
                    child: Text(
                      "그룹 삭제",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SearchButton(),
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
  final VoidCallback onKickout;

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
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: members.length,
          itemBuilder: (context, index) {
            return MemberTile(
              name: members[index]['nickName'] ?? 'member_name',
              uid: members[index]['uid'] ?? 'member_uid',
              groupId: groupId,
              onKickout: () => onKickout(),
            );
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class MemberTile extends StatelessWidget {
  final String name;
  final String uid;
  final String groupId;
  final VoidCallback onKickout;

  const MemberTile({
    super.key,
    required this.name,
    required this.uid,
    required this.groupId,
    required this.onKickout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.black),
        title: Text(name),
        trailing: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          onPressed: () async {
            onKickout();
          },

          child: Text("내보내기", style: TextStyle(color: Colors.red)),
        ),
      ),
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
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: members.length,
          itemBuilder: (context, index) {
            return OwnerTile(name: members[index]['nickName'] ?? 'member_name');
          },
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class OwnerTile extends StatelessWidget {
  final String name;

  const OwnerTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.black),
        title: Text(name),
      ),
    );
  }
}
