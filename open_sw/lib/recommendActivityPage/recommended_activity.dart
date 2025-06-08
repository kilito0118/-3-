import 'package:flutter/material.dart';
import 'package:open_sw/recommendPlacePage/set_place_page.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:open_sw/services/category_info.dart';

import 'package:open_sw/services/activity_info.dart';

class RecommendedActivity extends StatefulWidget {

  final String activity;
  final String groupId;
  final int type;

  const RecommendedActivity({
    super.key,
    required this.activity,
    required this.groupId,
    required this.type,
  });


  @override
  State<RecommendedActivity> createState() => _RecommendedActivityState();
}

class _RecommendedActivityState extends State<RecommendedActivity> {

  @override
  Widget build(BuildContext context) {

            ),
            child: Row(
              children: [
                getPrimeIcon(widget.activityNum, 65),
                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activityList[widget.activityNum]['name'],
                        style: contentsBig(fontWeight: FontWeight.bold),
                      ),
                      spacingBox_mini(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SetPlacePage(groupId: widget.groupId,
                        activity: widget.activity,
                        type: widget.type,
                              ),
                            ),
                          );
                        },
                        style: btn_small(),
                        child: Text('장소 검색하기'),
                      )
                    ],
                  ),
                )
              ],
            )
          )
        ),
        spacingBox(),
      ],
    );
  }
}
