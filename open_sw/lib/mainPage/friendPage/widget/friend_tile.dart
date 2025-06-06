import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

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
          child: ContentsBox(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // 친구 프로필 (지금은 그냥 이름 첫글자로 해둠)
                          if (friend.name == "팔로우 목록이 없어요.")
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.question_mark, color: Colors.white),
                            )
                          else
                            CircleAvatar(
                              radius: 20,
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
                    if (friend.name != "팔로우 목록이 없어요.")
                      TextButton(
                        onPressed: () {
                          showCustomAlert(
                            context: context,
                            title: '정말 삭제하시겠습니까?',
                            message: '삭제하시면 다시 팔로우하기 전까지 그룹원으로 추가할 수 없습니다.',
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    style: btn_normal(),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 그냥 닫기
                                    },
                                    child: Text('취소'),
                                  ),
                                ),
                                spacingBox(),
                                Expanded(
                                  child: TextButton(
                                    style: btn_normal(themeColor: themeRed),
                                    child: Text('삭제'),
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

                                        Navigator.of(context).pop();
                                        showCustomDialog(
                                          context: context,
                                          title: '삭제되었습니다',
                                          message: '삭제된 팔로워는 이후 다시 팔로우 할 수 있어요.',
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: TextButton(
                                              style: btn_normal(),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                onTap();
                                              },
                                              child: Text('확인'),
                                            ),
                                          )
                                        );// 친구 목록 갱신
                                      }
                                    },
                                  ),
                                )
                              ],
                            )
                          );
                        },
                        style: btn_small(
                          themeColor: themeRed
                        ),
                        child: Text('팔로워 삭제'),
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
