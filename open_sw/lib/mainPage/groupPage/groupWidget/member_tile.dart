import 'package:flutter/material.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:open_sw/useful_widget/profile_circle_widget.dart';

Widget memberTile({
  required String name,
  required String uid,
  required String email,
  required Widget child,
}) {
  return Column(
    children: [
      contentsBox(
        child: Row(
          children: [
            // 프로필 사진
            profileCircle(
              radius: 20,
              // ignore: deprecated_member_use
              backgroundColor: Color(uid.hashCode % 0xFFFFFF).withOpacity(1.0),
              child: Text(
                name[0],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
            spacingBox(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: contentsNormal(fontWeight: FontWeight.bold),
                  ),
                  Text(email, style: contentsDetail),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
      spacingBox(),
    ],
  );
}
