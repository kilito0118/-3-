import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/group_plus_tile_widget.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/group_tile_widget.dart';
import 'package:open_sw/mainPage/groupPage/group_detail_page_owner.dart';
import 'package:open_sw/mainPage/groupPage/regist_group.dart';
import 'package:open_sw/useful_widget/commonWidgets/colors/theme_colors.dart';
import 'package:open_sw/useful_widget/commonWidgets/spacing_widgets.dart';
import 'package:open_sw/useful_widget/commonWidgets/text_style_form.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.userName});
  final String userName;
  @override
  State<StatefulWidget> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  void onTab() {
    setState(() {
      _futureGroups = fetchUserGroups();
    });
  }

  Future<void> onTabGroupPlus() async {
    setState(() {
      _futureGroups = fetchUserGroups();
    });
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

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupDetailPageOwner(groupId: groupId),
        ),
      );
      print(result);
      if (result == true) {
        // 새로고침 (예: setState, 데이터 재요청 등)
        setState(() {
          _futureGroups = fetchUserGroups();
        });
      }
    } catch (e) {
      Navigator.pop(context);
      print(e);
    }
    setState(() {
      _futureGroups = fetchUserGroups();
    });

    // 초기화 작업이 필요하다면 여기에 작성
  }

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
    setState(() {});
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

  late Future<List<DocumentSnapshot>> _futureGroups;
  @override
  void initState() {
    super.initState();
    _futureGroups = fetchUserGroups();
  }

  //List<Group> groups;
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themePageColor,
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _futureGroups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final groups = snapshot.data ?? [];
            final groupCounts = groups.length;

            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    mainTitle('안녕하세요 🖐️\n${widget.userName} 님'),
                    spacingBox(),
                    subTitle('나의 그룹'),
                    SizedBox(height: 10),

                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 10),
                      itemCount: groupCounts + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < groupCounts) {
                          return GroupTileWidget(
                            group: groups[index],
                            onTap: () {
                              setState(() {
                                _futureGroups = fetchUserGroups();
                              });
                            },
                          );
                        } else {
                          return GroupPlusTileWidget(
                            onTap: () async {
                              await onTabGroupPlus();
                              setState(() {
                                _futureGroups = fetchUserGroups();
                              });
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 80),
                    Text(""),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
