import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/group_plus_tile_widget.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/group_tile_widget.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.userName});
  final String userName;
  @override
  State<StatefulWidget> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  Future<List<DocumentSnapshot>> getGroupsByIds(List<String> groupIds) async {
    // 여러 개의 Future를 만들어서 병렬로 실행
    List<Future<DocumentSnapshot>> futures =
        groupIds.map((groupId) {
          return FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .get();
        }).toList();
    // 모든 Future가 끝나면 결과 리스트 반환

    return await Future.wait(futures);
  }

  Future<List<String>> getGroupIds() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    List<dynamic> groups = docSnapshot['groups'] ?? [];
    //print(groups);
    return List<String>.from(groups);
  }

  Future<List<DocumentSnapshot>> fetchUserGroups() async {
    // 1. 그룹 아이디 리스트 받아오기
    List<String> groupIds = await getGroupIds();

    // 2. 그룹 아이디로 그룹 문서들 가져오기
    if (groupIds.isNotEmpty) {
      List<DocumentSnapshot> groupDocs = await getGroupsByIds(groupIds);
      return groupDocs;
    } else {
      return [];
    }
  }

  //List<Group> groups;
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: fetchUserGroups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final groups = snapshot.data ?? [];

          //print(snapshot);
          final groupCounts = groups.length;
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 82, width: 26),
                    Text(
                      "안녕하세요,\n${widget.userName}님.",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 83),
                    Icon(Icons.account_circle_rounded, size: 68),
                  ],
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(left: 26, right: 26),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "나의 그룹",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                "편집",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              primary: false,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 10),
                              itemCount: groupCounts + 1,
                              itemBuilder: (BuildContext context, int index) {
                                print(groupCounts);
                                if (index < groupCounts) {
                                  return GroupTileWidget(group: groups[index]);
                                } else {
                                  return GroupPlusTileWidget();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
                Text(""),
              ],
            ),
          );
        }
        // Fallback widget in case none of the above conditions are met
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Center(child: Text('No data available')),
        );
      },
    );
  }
}
