import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class GroupPlusTileWidget extends StatelessWidget {
  const GroupPlusTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print(1);
          },
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(20),
              dashPattern: [10, 5],
              strokeWidth: 2,
              color: Color(0xff585858),
              padding: EdgeInsets.all(16),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "새 그룹 추가하기",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff585858),
                          fontWeight: FontWeight.w500,
                        ),
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
