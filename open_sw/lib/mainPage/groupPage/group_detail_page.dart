import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/friend_plus_at_group_widget.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/search_button_widget.dart';

class GroupDetailPage extends StatefulWidget {
  final DocumentSnapshot? group;
  final String? groupId;

  const GroupDetailPage({super.key, this.group, this.groupId});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  Map<String, dynamic>? groupData;
  List<Map> memberDetails = [];
  bool isLoading = true;
  Map<String, dynamic>? data;
  DocumentSnapshot? docSnapshot;

  String leaderName = '그룹장2 이름';
  @override
  void initState() {
    super.initState();
    //print(widget.group?.data() as Map<String, dynamic>?);

    setState(() {
      _loadGroupData();
    });
  }

  Future<void> getName(String id, int type) async {
    DocumentSnapshot nameSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    //print(nameSnapshot.data());
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
      docSnapshot = widget.group;
      //print(data);
    } else if (widget.groupId != null) {
      docSnapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(widget.groupId)
              .get();

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
    // print("그룹 데이터: $groupData");
    //print(widget.groupId);
    if (groupData == null || isLoading) {
      return Scaffold(
        body: Center(child: Text('데이터를 불러올 수 없습니다.')),
        floatingActionButton: FloatingActionButton(
          onPressed: _loadGroupData, // 새로고침
          child: Icon(Icons.refresh),
        ),
      );
    }
    List<dynamic> members = groupData!['members'] ?? [];
    //print(memberDetails);
    // 그룹장/그룹원 분리 예시 (실제 로직에 맞게 수정 필요)

    List<String> memberNames =
        memberDetails.isNotEmpty
            ? memberDetails
                .sublist(1)
                .map((m) => m['name'] ?? 'member_name')
                .cast<String>()
                .toList()
            : ['member_name'];
    //print("그룹원 이름들: $memberDetails");
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
                      groupData!['name'] ?? "Group_name",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {},
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
              MemberSection(
                title: "그룹장",
                members: [
                  {'nickName': leaderName},
                ],
              ),

              memberDetails.isNotEmpty
                  ? MemberSection(title: "그룹원", members: memberDetails)
                  : Text(""),

              //MemberSection(title: "그룹원", members: memberNames),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
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
                  SearchButton(),
                  SizedBox(height: 10),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
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

  const MemberSection({super.key, required this.title, required this.members});

  @override
  Widget build(BuildContext context) {
    print(members);
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

  const MemberTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    print(name);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.black,

          child: Text(
            name[0],

            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
        ),
        title: Text(name),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
