import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:open_sw/useful_widget/profile_circle_widget.dart';

class Friend {
  final String name;
  final String uid;
  final String email;

  Friend({
    required this.name,
    required this.uid,
    this.email = "example@gmail.com",
  });
}

class FriendTile extends StatelessWidget {
  final Friend friend;
  final VoidCallback onTap;

  const FriendTile({super.key, required this.friend, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        contentsBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // 친구 프로필 (지금은 그냥 이름 첫글자로 해둠)
                    if (friend.name == "팔로우 목록이 없어요.")
                      profileCircle(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.question_mark, color: Colors.white),
                      )
                    else
                      profileCircle(
                        radius: 20,
                        backgroundColor: Color(
                          friend.uid.hashCode % 0xFFFFFF,
                          // ignore: deprecated_member_use
                        ).withOpacity(1.0), // 이름 해시값으로 색상 생성
                        child: Text(
                          friend.name[0],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    spacingBox(),

                    // 친구 이름
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend.name,
                          style: contentsNormal(fontWeight: FontWeight.bold),
                        ),
                        Text(friend.email, style: contentsDetail),
                      ],
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
                              style: btnNormal(),
                              onPressed: () {
                                Navigator.of(context).pop(); // 그냥 닫기
                              },
                              child: Text('취소'),
                            ),
                          ),
                          spacingBox(),
                          Expanded(
                            child: TextButton(
                              style: btnNormal(themeColor: themeRed),
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
                                              .update({'friends': friends});
                                        } else {
                                          debugPrint(
                                            'Document does not exist on the database',
                                          );
                                        }
                                      })
                                      .catchError((error) {
                                        debugPrint(
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
                                        style: btnNormal(),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          onTap();
                                        },
                                        child: Text('확인'),
                                      ),
                                    ),
                                  ); // 친구 목록 갱신
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: btnSmall(themeColor: themeRed),
                  child: Text('팔로워 삭제'),
                ), // 상세 버튼 (점3개 아이콘)
            ],
          ),
        ),
        spacingBox(),// tile별 거리 확보
      ],
    );
  }
}
