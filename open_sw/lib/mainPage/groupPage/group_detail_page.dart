import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:open_sw/mainPage/groupPage/friend_plus_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _loadGroupData();
  }

  Future<void> _loadGroupData() async {
    Map<String, dynamic>? data;
    if (widget.group != null && widget.group!.exists) {
      data = widget.group!.data() as Map<String, dynamic>?;
    } else if (widget.groupId != null) {
      final docSnapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(widget.groupId)
              .get();
      if (docSnapshot.exists) {
        data = docSnapshot.data();
      }
    }
    if (data != null) {
      List<dynamic> members = data['members'] ?? [];
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
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (groupData == null) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(child: Text('그룹 정보를 찾을 수 없습니다.')),
      );
    }
    List<dynamic> members = groupData!['members'] ?? [];

    // 그룹장/그룹원 분리 예시 (실제 로직에 맞게 수정 필요)
    String leaderName =
        memberDetails.isNotEmpty
            ? (memberDetails[0]['name'] ?? 'member_name')
            : 'member_name';
    List<String> memberNames =
        memberDetails.length > 1
            ? memberDetails
                .sublist(1)
                .map((m) => m['name'] ?? 'member_name')
                .cast<String>()
                .toList()
            : ['member_name'];

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
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: 0,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox.shrink();
                },
              ),
              ActivityCard(date: "00.00(화)", place: "장소 이름"),
              ActivityCard(date: "00.00(수)", place: "장소 이름"),
              SizedBox(height: 20),
              MemberSection(title: "그룹장", members: [leaderName]),
              MemberSection(title: "그룹원", members: memberNames),
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
                            child: FriendPlusWidget(),
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

  const ActivityCard({required this.date, required this.place});

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
  final List<String> members;

  const MemberSection({required this.title, required this.members});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ...members.map((name) => MemberTile(name: name)).toList(),
        SizedBox(height: 10),
      ],
    );
  }
}

class MemberTile extends StatelessWidget {
  final String name;

  const MemberTile({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.black),
        title: Text(name),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
