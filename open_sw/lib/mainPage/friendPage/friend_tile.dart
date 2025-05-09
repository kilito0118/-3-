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
            print(friend.name); // 친구 버튼 클릭하면 이름 출력 (나중에는 상세탭으로 이동)
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
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert),
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
