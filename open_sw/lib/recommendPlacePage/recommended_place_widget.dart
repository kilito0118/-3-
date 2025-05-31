import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        /*
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ]
        */
      ),
      /// 넘치는 요소 자르기
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: 14),

      /// 장소 메뉴
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.place['name'] ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        softWrap: true,
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        widget.place['address'] ?? '',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),

                GestureDetector(
                  onTapDown: _addTapDown,
                  onTapUp: _addTapUp,
                  onTapCancel: _addTapCancel,
                  child: AnimatedScale(
                    scale: _scale,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutBack,
                    child: Container(
                        margin: EdgeInsets.only(top: 4),
                        width: 100,
                        height: 28,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF9933), const Color(0xFFFF6600)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x7FFF9933),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ]
                        ),
                        child: Center(
                          child: Text(
                            '일정에 등록',
                            style: TextStyle(
                                color: Colors.white, fontSize: 16
                            ),
                          ),
                        )
                    ),
                  ),
                ),

              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Colors.grey[300] ?? Colors.grey,
                  Color(0xFFFFFFFF)
                ]
              )
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 3,
                colors: [
                  Colors.grey[100] ?? Colors.grey,
                  Colors.white
                ],
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),

                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: _phone.isNotEmpty ? Color(0xFF52A658) : Colors.grey,
                    padding: EdgeInsets.all(0),
                    minimumSize: Size(144, 44)
                  ),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('전화걸기', style: TextStyle(fontSize: 14),),
                      SizedBox(width: 4,),
                      Icon(Icons.add_call, size: 20,),
                    ],
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(144, 44)
                    ),
                    onPressed: () {
                      final url = "https://place.map.kakao.com/${widget.place['id']}";
                      _launchUrl(url);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('지도에서 보기', style: TextStyle(fontSize: 14),),
                        SizedBox(width: 4,),
                        Icon(Icons.open_in_new, size: 20,),
                      ],
                    ),
                ),
                SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

