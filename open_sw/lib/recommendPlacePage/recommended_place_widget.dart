import 'package:flutter/material.dart';
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

  /// 추가버튼 동작
  void _addTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95; // 작아짐
    });
  }
  void _addTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // 원래 크기로 복원
    });
    // 일정추가 창 띄우는 기능 만드는중
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(80),
      builder: (context) {
        return Container();
      }
    );
  }
  void _addTapCancel() {
    setState(() {
      _scale = 1.0; // 터치 취소시 복원
    });
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

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(36),
              blurRadius: 8,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ]
      ),
      margin: EdgeInsets.only(right: 7, left: 7, top: 24),
      child: ClipRRect(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF).withAlpha(160),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border.all(
                      color: Colors.white.withAlpha(160),
                      width: 1.2
                  )
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                  GestureDetector(
                    onTapDown: _addTapDown,
                    onTapUp: _addTapUp,
                    onTapCancel: _addTapCancel,
                    child: AnimatedScale(
                      scale: _scale,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutBack,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: themeGradient(),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x7FFF9933),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                              spreadRadius: 0
                            )
                          ]
                        ),
                        child: Text(
                          '일정에 추가하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              ),
            )
        ),
      ),
    );
  }
}
