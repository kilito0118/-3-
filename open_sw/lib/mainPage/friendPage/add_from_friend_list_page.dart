import 'package:flutter/material.dart';

class AddFromFriendListPage extends StatefulWidget {
  const AddFromFriendListPage({super.key});

  @override
  State<AddFromFriendListPage> createState() => _AddFromFriendListPageState();
}

class _AddFromFriendListPageState extends State<AddFromFriendListPage> {
  final TextEditingController _searchController = TextEditingController();

  List<String> allFriends = ['friend_name', 'friend_name', 'friend_name'];
  List<String> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = List.from(allFriends);
  }

  void _filterFriends(String keyword) {
    setState(() {
      filteredFriends =
          allFriends
              .where(
                (name) => name.toLowerCase().contains(keyword.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      leading: CircleAvatar(backgroundColor: Colors.black),
                      title: Text(name),
                      trailing: TextButton(
                        onPressed: () {
                          print("$name 그룹에 추가됨");
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
