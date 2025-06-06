import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/friendPage/widget/friend_plus_widget.dart';
import 'widget/friend_tile.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  TextEditingController controller = TextEditingController();

  List<Friend> friends = [];
  List<Map<String, String>> friendDetails = [];
  Future<void> onTap() async {
    setState(() {});
    await beforeStart(); // 친구 목록 새로고침
    setState(() {});
  }

  Future<void> beforeStart() async {
    friendDetails.clear();
    friends.clear();
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
                                (detail) => Friend(
                                  name: detail['nickName']!,
                                  uid: detail['uid']!,
                                ),
                              )
                              .toList();
                    });
                  }
                });
          }
        }
      });
    } else {
      print('로그인된 사용자가 없습니다.');
    }
  }

  @override
  initState() {
    beforeStart(); // 친구 목록 초기화
    super.initState();
  }

  Future<String?> getUid(String email) async {
    final userSnapshot = FirebaseAuth.instance.currentUser;
    Map<String, dynamic>? userData = userSnapshot as Map<String, dynamic>?;

    if (email == userData!['email']) {
      return userSnapshot?.uid; // 현재 로그인한 사용자의 uid 반환
    }
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // uid 반환
    } else {
      return null; // 해당 이메일이 없을 때
    }
  }

  Future<void> addFriend(String friendUid) async {
    // 현재 로그인한 사용자의 uid 가져오기
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('로그인된 사용자가 없습니다.');
      return;
    }
    final myUid = currentUser.uid;

    // 내 users 문서의 참조
    final myDocRef = FirebaseFirestore.instance.collection('users').doc(myUid);

    // friend 배열에 friendUid 추가 (중복 없이)
    await myDocRef.update({
      'friends': FieldValue.arrayUnion([friendUid]),
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(friendDetails);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent, // 배경색 설정
        appBar: PreferredSize(
          // '친구' 부분 (appbar)
          preferredSize: Size.fromHeight(135),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text(
                  '팔로우 목록',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          // 친구 추가 버튼 + 친구 목록 (body)
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 친구 추가 버튼
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity - 20),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromRGBO(255, 152, 49, 1),
                        const Color.fromRGBO(255, 104, 2, 1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 203, 144, 55),
                        spreadRadius: 1,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      '이메일로 팔로우하기',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,

                        useSafeArea: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        constraints: BoxConstraints(
                          minHeight: 300,
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                          maxWidth: 320,
                        ),
                        elevation: 800,

                        builder: (context) {
                          return FriendPlusWidget(
                            controller: controller,
                            onAddFriend: () async {
                              String? uid = await getUid(controller.text);

                              if (uid != null) {
                                print('해당 이메일의 uid: $uid');
                                addFriend(uid);
                              } else {
                                print('해당 이메일을 가진 사용자가 없습니다.');
                              }
                              setState(() {
                                controller.clear(); // 입력 필드 초기화
                                Navigator.pop(context); // 모달 닫기
                                beforeStart(); // 친구 목록 새로고침
                              });
                            },
                          );
                          // 원하는 위젯 추가
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              // 친구 목록
              Text(
                '내 팔로우 목록',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
              // 친구 목록 출력 (friend_tile.dart에 자세한 코드 있음)
              friends.isEmpty
                  ? FriendTile(
                    friend: Friend(name: "팔로우가 없어요.", uid: ''),
                    onTap: () => onTap(),
                  )
                  : Text(""),
              Expanded(
                child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return FriendTile(friend: friends[index], onTap: onTap);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
