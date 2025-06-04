import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Friend {
  final String name;
  final String uid;

  Friend({required this.name, required this.uid});
}

class FriendTile extends StatelessWidget {
  final Friend friend;
  final VoidCallback onTap;

  const FriendTile({super.key, required this.friend, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            //(friend.name); // 친구 버튼 클릭하면 이름 출력 (나중에는 상세탭으로 이동)
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: EdgeInsets.only(right: 8), // 아이콘과 간격
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // 친구 프로필 (지금은 그냥 이름 첫글자로 해둠)
                          if (friend.name == "팔로우가 없어요.")
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Icon(Icons.person, color: Colors.white),
                            )
                          else
                            CircleAvatar(
                              backgroundColor: Color(
                                friend.uid.hashCode % 0xFFFFFF,
                              ).withOpacity(1.0), // 이름 해시값으로 색상 생성
                              child: Text(
                                friend.name[0],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          SizedBox(width: 10),
                          // 친구 이름
                          Text(
                            friend.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (friend.name != "팔로우가 없어요.")
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  '정말 팔로우를 삭제하시겠습니까?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                content: Text(
                                  '삭제하시면 이제 그룹원으로 추가할 수 없습니다.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        Colors.white,
                                      ),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '취소',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 그냥 닫기
                                    },
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        Colors.red,
                                      ),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '삭제',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () {
                                      final currentUser =
                                          FirebaseAuth.instance.currentUser;

                                      if (currentUser != null) {
                                        final currentUid = currentUser.uid;

                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(currentUid)
                                            .get()
                                            .then((
                                              DocumentSnapshot documentSnapshot,
                                            ) {
                                              if (documentSnapshot.exists) {
                                                final data =
                                                    documentSnapshot.data()
                                                        as Map<String, dynamic>;
                                                List<dynamic> friends =
                                                    data['friends'] ?? [];
                                                friends.remove(
                                                  friend.uid,
                                                ); // 친구 UID 제거
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(currentUid)
                                                    .update({
                                                      'friends': friends,
                                                    });
                                              } else {
                                                print(
                                                  'Document does not exist on the database',
                                                );
                                              }
                                            })
                                            .catchError((error) {
                                              print(
                                                'Error fetching document: $error',
                                              );
                                            });

                                        Navigator.of(context).pop(); // 닫기
                                        onTap(); // 친구 목록 갱신
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.close_rounded),
                        color: Colors.red,
                      ), // 상세 버튼 (점3개 아이콘)
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10), // tile별 거리 확보
      ],
    );
  }
}
