import 'package:flutter/material.dart';
import 'package:open_sw/main.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

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
  double _scale = 1.0;

  void openTimeSelect() {
    // 일정추가 창 띄우는 기능 만드는중
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(40),
      builder: (context) {
        return BlurredBox(
          width: double.infinity,
          topRad: 20,
          alpha: 200,
          horizontalPadding: 14.0,
          verticalPadding: 0.0,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainTitle('언제 모이나요?'),
              subTitle(widget.place['name'] ?? ''),
              spacingBox(),
              subTitle('날짜 및 시간 입력'),
              spacingBox(),
              Container(

              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: btn_normal(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.black.withAlpha(15)
                  ),
                  child: Text('2000년 00월 00일'),
                ),
              ),
              spacingBox(),
              subTitle('시간 입력'),
              spacingBox(),
              Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: btn_normal(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.black.withAlpha(15)
                          ),
                          child: Text('00 시'),
                        ),
                      ),
                      spacingBox(),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: btn_normal(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.black.withAlpha(15)
                          ),
                          child: Text('00 분'),
                        ),
                      )
                    ],
                  ),
              spacingBox(),
              SubmitButtonNormal(
                text: '그룹 일정에 추가',
                onTap: () {}
              ),
              bottomNavigationBarSpacer(context),
            ],
          )
        );
      }
    );
  }

  /// 링크 열기
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('링크를 열 수 없습니다')));
    }
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
              style: contentsBig,
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
                    btn_normal(
                        foregroundColor: Color(0xFF52A658),
                        backgroundColor: Color(0xFF52A658).withAlpha(30)
                    ) :
                    btn_normal(
                      foregroundColor: Colors.black.withAlpha(120),
                      backgroundColor: Colors.transparent,
                    ),
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
                      style: btn_normal(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.black.withAlpha(15),
                      ),
                      child: Text('지도에서 보기'),
                    )
                ),
              ],
            ),
            spacingBox_devider(),
            SubmitButtonNormal(
              text: '그룹 일정에 추가하기',
              onTap: openTimeSelect,
            ),
          ],
        ),
        topRad: 20,
        bottomRad: 0,
      ),
    );
  }
}
