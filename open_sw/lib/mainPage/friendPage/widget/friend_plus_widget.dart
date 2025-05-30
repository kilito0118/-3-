import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendPlusWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onAddFriend;

  const FriendPlusWidget({
    super.key,
    required this.controller,
    required this.onAddFriend,
  });

  @override
  State<FriendPlusWidget> createState() => _FriendPlusWidgetState();
}

class _FriendPlusWidgetState extends State<FriendPlusWidget> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    setState(() {
      userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320,
        height: 3000,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              width: 308,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF6F6F6)],
                ),
                //color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "나의 아이디",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      userEmail ?? '로딩 중...',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    TextField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintText: "추가할 친구의 아이디 입력",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: widget.onAddFriend,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          backgroundColor: const Color(0xFFFF7A00),
                          elevation: 0,
                        ),
                        child: Text(
                          "친구로 추가하기",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () => Navigator.pop(context),
                child: Container(height: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
