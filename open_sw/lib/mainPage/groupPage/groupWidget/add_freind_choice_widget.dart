import 'package:flutter/material.dart';

class AddFriendChoiceWidget extends StatelessWidget {
  const AddFriendChoiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 308,
          height: 190,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AddFriendOption(
                icon: Icons.person,
                label: "친구 목록에서\n추가하기",
                onTap: () {
                  Navigator.pushNamed(context, '/addFromList');
                },
              ),
              AddFriendOption(
                icon: Icons.edit,
                label: "직접 추가하기",
                onTap: () {
                  Navigator.pushNamed(context, '/manualAdd');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddFriendOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AddFriendOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Colors.black87),
            ),
            SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
