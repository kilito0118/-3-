import 'package:flutter/material.dart';

import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:open_sw/utils/open_url.dart';
import 'package:open_sw/utils/time_to_text.dart';
import 'recent_activity.dart';

class UpcomingActivityTile extends StatefulWidget {
  final Activity recentAct;
  final String actId; // 그룹 ID가 필요할 경우 추가

  const UpcomingActivityTile({
    super.key,
    required this.recentAct,
    required this.actId,
  });

  @override
  State<UpcomingActivityTile> createState() => _UpcomingActivityTileState();
}

class _UpcomingActivityTileState extends State<UpcomingActivityTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: paddingSmall, bottom: 14),
          width: 320,
          padding: EdgeInsets.symmetric(
            horizontal: paddingBig,
            vertical: paddingMid,
          ),
          decoration: BoxDecoration(
            gradient: themeGradient(),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: themeLightOrange.withAlpha(140),
                blurRadius: 8,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeToText(widget.recentAct.date),
                      style: contentsDetailWhite,
                    ),
                    Text(
                      '${widget.recentAct.date.hour.toString().padLeft(2, '0')}시 ${widget.recentAct.date.minute.toString().padLeft(2, '0')}분',
                      style: contentsDetailWhite,
                    ),
                    spacingBoxMini(),
                    Text(
                      widget.recentAct.place['name'] ?? '장소정보 없음',
                      style: contentsBig(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  final url =
                      "https://place.map.kakao.com/${widget.recentAct.place['id']}";
                  openUrl(url);
                },
                style: btnSmall(themeColor: Colors.white),
                child: Text('지도열기'),
              ),
            ],
          ),
        ),
        spacingBox(),
      ],
    );
  }
}
