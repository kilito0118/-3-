import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/friendPage/widget/friend_plus_widget.dart';
import 'widget/friend_tile.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

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
                    String Email = friendDoc.data()?['email'] ?? 'Unknown';
                    friendDetails.add({
                      'uid': friendUid,
                      'nickName': nickName,
                      'email': Email,
                    });

                    setState(() {
                      friends =
                          friendDetails
                              .map(
                                (detail) => Friend(
                                  name: detail['nickName']!,
                                  uid: detail['uid']!,
                                  email: detail['email']!,
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final uid = user.uid;
    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>;

    if (email == userData!['email']) {
      return null; // 현재 로그인한 사용자의 uid 반환
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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainTitle('팔로우 목록'),
              spacingBox(),
              SubmitButtonBig(
                text: '팔로우 추가하기',
                onTap: () {
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
              spacingBox(),
              // 친구 목록
              subTitle('나의 팔로우 목록'),
              SizedBox(height: 10),
              // 친구 목록 출력 (friend_tile.dart에 자세한 코드 있음)
              friends.isEmpty
                  ? FriendTile(
                    friend: Friend(
                      name: "팔로우 목록이 없어요.",
                      uid: '',
                      email: '새 팔로워를 추가해보세요',
                    ),
                    onTap: () => onTap(),
                  )
                  : Expanded(
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
