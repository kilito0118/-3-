import 'package:flutter/material.dart';
import 'package:open_sw/main.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import 'date_selector_modal.dart';

class RecommendedPlaceWidget extends StatefulWidget {
  final Map<String, String> place;

  const RecommendedPlaceWidget({
    super.key,
    required this.place
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('링크를 열 수 없습니다')));
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
          selectedDate: now.add(Duration(days: 1)),
          place: widget.place,
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final _phone = widget.place['phone'] ?? '';

    return Padding(
      padding: EdgeInsets.only(right: 7, left: 7, top: 24),
      child: BlurredBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.place['name'] ?? '',
              style: contentsTitle(),
            ),
            spacingBox_mini(),
            Text(
              widget.place['address'] ?? '',
              style: contentsDetail,
            ),
            spacingBox(),
            Row(
              children: [
                Expanded(
                  // 전화버튼
                  child: TextButton(
                    onPressed: () {
                      if(_phone.isNotEmpty){
                        _launchUrl('tel:$_phone');
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('전화번호가 없습니다.')),
                        );
                      }
                    },
                    style: _phone.isNotEmpty ?
                    btn_normal(themeColor: themeGreen) :
                    btn_normal(themeColor: Colors.grey),
                    child: Text('전화걸기'),
                  ),
                ),
                spacingBox(),
                Expanded(
                    child: TextButton(
                      onPressed: () {
                        final url = "https://place.map.kakao.com/${widget.place['id']}";
                        _launchUrl(url);
                      },
                      style: btn_normal(),
                      child: Text('지도에서 보기'),
                    )
                ),
              ],
            ),
            spacingBox_devider(),
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
