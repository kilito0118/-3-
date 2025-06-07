import 'package:flutter/material.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

Widget memberTile({
  required String name,
  required String uid,
  required Widget child
}) {
  return Column(
    children: [
      ContentsBox(
        child: Row(
          children: [
            // 프로필 사진
            CircleAvatar(
              radius: 22,
              backgroundColor: Color(uid.hashCode % 0xFFFFFF).withOpacity(1.0),
              child: Text(
                name[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            spacingBox(),
            Expanded(
              child: Text(name, style: contentsNormal(),),
            ),
            child
          ],
        )
      ),
      spacingBox()
    ],
  );
}