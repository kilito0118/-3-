import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:open_sw/mainPage/groupPage/add_from_friend_list_page.dart';
import 'package:open_sw/mainPage/groupPage/manual_add_page.dart';

class FriendPlusAtGroupWidget extends StatefulWidget {
  final DocumentSnapshot<Object?>? groupDocument;
  final void Function() logic;
  const FriendPlusAtGroupWidget({
    super.key,
    required this.groupDocument,
    required this.logic,
  });

  @override
  State<FriendPlusAtGroupWidget> createState() =>
      _FriendPlusAtGroupWidgetState();
}

class _FriendPlusAtGroupWidgetState extends State<FriendPlusAtGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // 모서리 둥글게
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AddFriendButton(
              icon: Icons.person_outline,
              label: '팔로우 목록에서\n추가하기',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AddFromFriendListPage(
                          logic: widget.logic,
                          groupDocument: widget.groupDocument,
                        ),
                  ),
                );

                widget.logic();
              },
            ),
            const SizedBox(width: 32),
            _AddFriendButton(
              icon: Icons.edit_outlined,
              label: '직접 추가하기',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ManualAddPage(
                          groupId: widget.groupDocument!.id,
                          logic: widget.logic,
                        ),
                  ),
                );
                widget.logic();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AddFriendButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AddFriendButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 36, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
