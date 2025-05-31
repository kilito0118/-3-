import 'package:flutter/material.dart';

class Friend {
  final String name;

  Friend({required this.name});
}

class FriendTile extends StatelessWidget {
  final Friend friend;

  const FriendTile({super.key, required this.friend});

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
                              backgroundColor: Colors.black,
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
                                  '정말 팔로우를 취소하시겠습니까?',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                content: Text(
                                  '취소하시면 이제 그룹원으로 추가할 수 없습니다.',
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
                                      Navigator.of(context).pop(); // 닫기

                                      // 삭제 로직 추가
                                      print('삭제');
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
