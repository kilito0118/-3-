import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

class GroupPlusTileWidget extends StatelessWidget {
  final void Function() onTap;
  const GroupPlusTileWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            onTap();
          },
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(20),
              dashPattern: [10, 5],
              strokeWidth: 2,
              color: Colors.black.withAlpha(80),
              padding: EdgeInsets.all(16),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "새 그룹 추가하기",
                        style: contentsNormal(color: Colors.black.withAlpha(80))
                      ),
                    ),
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
