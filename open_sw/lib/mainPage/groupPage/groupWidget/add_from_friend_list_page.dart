import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/friendPage/widget/friend_tile.dart';

class AddFromFriendListPage extends StatefulWidget {
  final DocumentSnapshot<Object?>? groupDocument;

  const AddFromFriendListPage({super.key, this.groupDocument});

  @override
  State<AddFromFriendListPage> createState() => _AddFromFriendListPageState();
}

class _AddFromFriendListPageState extends State<AddFromFriendListPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<void> addMemberToSnapshot(
    DocumentSnapshot<Object?>? documentSnapshot,
    String newUid,
  ) async {
    if (documentSnapshot == null) {
      print('documentSnapshot이 null입니다!');
      return;
    }
    await documentSnapshot.reference.update({
      'members': FieldValue.arrayUnion([newUid]),
    });
  }

  //List<String> allFriends = ['friend_name', 'friend_name', 'friend_name'];
  List<Map<String, String>> filteredFriends = [];
  List<Friend> friends = [];
  List<Map<String, String>> friendDetails = [];
  @override
  initState() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final myUid = currentUser.uid;

      // Firestore에서 현재 사용자의 친구 목록을 가져오기
      FirebaseFirestore.instance.collection('users').doc(myUid).get().then((
        doc,
      ) {
        if (doc.exists) {
          List<dynamic> friendList = doc.data()?['friends'] ?? [];

          for (String friendUid in friendList) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(friendUid)
                .get()
                .then((friendDoc) {
                  if (friendDoc.exists) {
                    String nickName =
                        friendDoc.data()?['nickName'] ?? 'Unknown';
                    friendDetails.add({'uid': friendUid, 'nickName': nickName});

                    setState(() {
                      friends =
                          friendDetails
                              .map(
                                (detail) => Friend(name: detail['nickName']!),
                              )
                              .toList();
                    });
                  }
                });
          }
        }
      });
      //print(friendDetails);
    } else {
      print('로그인된 사용자가 없습니다.');
    }

    super.initState();
  }

  void _filterFriends(String keyword) {
    setState(() {
      filteredFriends =
          friendDetails.where((friend) {
            String nickName = friend['nickName'] ?? '';
            return nickName.toLowerCase().contains(keyword.toLowerCase());
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _filterFriends(_searchController.text);
    //print(filteredFriends);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text("친구 목록에서 추가", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // 검색창
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterFriends,
                decoration: InputDecoration(
                  hintText: "이름으로 검색",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "내 친구",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            // 친구 목록
            Expanded(
              child: ListView.builder(
                itemCount: filteredFriends.length,
                itemBuilder: (context, index) {
                  final name = filteredFriends[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Text(
                          name['nickName'] == null
                              ? "닉네임 없음"
                              : name['nickName']![0],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      title:
                          name['nickName'] != null
                              ? Text(name['nickName']!)
                              : Text(""),
                      trailing: TextButton(
                        onPressed: () {
                          addMemberToSnapshot(
                            widget.groupDocument,
                            name['uid']!,
                          );
                          Navigator.pop(context);
                        },
                        child: Text("그룹에 추가하기"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.deepOrange,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
