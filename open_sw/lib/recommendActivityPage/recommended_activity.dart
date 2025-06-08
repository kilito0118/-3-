import 'package:flutter/material.dart';
import 'package:open_sw/recommendPlacePage/set_place_page.dart';
import 'package:open_sw/services/activity_info.dart';
import 'package:open_sw/services/category_info.dart';
import 'package:open_sw/useful_widget/commonWidgets/buttons_styles.dart';
import 'package:open_sw/useful_widget/commonWidgets/spacing_widgets.dart';
import 'package:open_sw/useful_widget/commonWidgets/text_style_form.dart';
import 'package:open_sw/useful_widget/commonWidgets/touch_react_box.dart';

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
    return Column(
      children: [
        TouchReactBox(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SetPlacePage(
                        type: widget.type,
                        activity: '',
                        groupId: widget.groupId,
                      ),
                ),
              );
            },

            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [],
              ),
              child: Row(
                children: [
                  getPrimeIcon(widget.type, 65),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activityList[widget.type]['name'],
                          style: contentsBig(fontWeight: FontWeight.bold),
                        ),
                        spacingBox_mini(),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => SetPlacePage(
                                      type: widget.type,
                                      activity: '',
                                      groupId: widget.groupId,
                                    ),
                              ),
                            );
                          },
                          style: btn_small(),
                          child: Text('장소 검색하기'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        spacingBox(),
      ],
    );
  }
}
