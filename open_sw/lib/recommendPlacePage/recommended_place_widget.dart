import 'package:flutter/material.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'date_selector_modal.dart';

class RecommendedPlaceWidget extends StatefulWidget {
  final Map<String, String> place;
  final int type;
  final String groupId;

  const RecommendedPlaceWidget({
    super.key,
    required this.place,
    required this.type,
    required this.groupId,
  });

  @override
  State<RecommendedPlaceWidget> createState() => _RecommendedPlaceWidgetState();
}

class _RecommendedPlaceWidgetState extends State<RecommendedPlaceWidget> {
  // 링크 열기
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('링크를 열 수 없습니다')));
      }
    }
  }

  // 일정 선택 및 추가 창
  void openTimeSelectScreen() {
    DateTime now = DateTime.now();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(40),
      builder: (context) {
        return DateSelectorModal(
          type: widget.type,
          selectedDate: now.add(Duration(days: 1)),
          place: widget.place,
          groupId: widget.groupId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = widget.place['phone'] ?? '';

    return Padding(
      padding: EdgeInsets.only(right: 7, left: 7, top: 24),
      child: blurredBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.place['name'] ?? '', style: contentsTitle()),
            spacingBoxMini(),
            Text(widget.place['address'] ?? '', style: contentsDetail),
            spacingBox(),
            Row(
              children: [
                Expanded(
                  // 전화버튼
                  child: TextButton(
                    onPressed: () {
                      if (phone.isNotEmpty) {
                        _launchUrl('tel:$phone');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('전화번호가 없습니다.')),
                        );
                      }
                    },
                    style:
                        phone.isNotEmpty
                            ? btnNormal(themeColor: themeGreen)
                            : btnNormal(themeColor: Colors.grey),
                    child: Text('전화걸기'),
                  ),
                ),
                spacingBox(),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      final url =
                          "https://place.map.kakao.com/${widget.place['id']}";
                      _launchUrl(url);
                    },
                    style: btnNormal(),
                    child: Text('지도에서 보기'),
                  ),
                ),
              ],
            ),
            spacingBoxDevider(),
            SubmitButtonNormal(
              text: '그룹 일정에 추가하기',
              onTap: openTimeSelectScreen,
            ),
          ],
        ),
        topRad: 20,
        bottomRad: 0,
      ),
    );
  }
}
