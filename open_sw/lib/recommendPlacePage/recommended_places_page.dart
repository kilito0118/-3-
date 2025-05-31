import 'package:flutter/material.dart';
// common_widgets 임포트
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
// 추천 목록 타일
import 'recommended_place_widget.dart';
// 검색 알고리즘
import 'package:open_sw/services/map_api_services.dart';

class RecommendedPlacesPage extends StatefulWidget {
  final String posName;
  final double lat;
  final double lng;

  final String activity;

  const RecommendedPlacesPage({
    super.key,
    required this.posName,
    required this.lat,
    required this.lng,
    required this.activity
  });

  @override
  State<RecommendedPlacesPage> createState() => _RecommendedPlacesPageState();
}

class _RecommendedPlacesPageState extends State<RecommendedPlacesPage> {
  List<Map<String, String>> places = [];

  @override
  void initState(){
    super.initState();
    searchPlaces();
  }

  void searchPlaces() async {
    try {
      final nearby = await findNearbyPlaces(
        latitude: widget.lat,
        longitude: widget.lng,
        query: widget.activity,
      );
      setState(() => places = nearby);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: defaultAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topAppBarSpacer(context),
                mainTitle('${widget.posName}\n주변 장소에요'),
                spacingBox(),
                ...List.generate(places.length, (index) {
                  return RecommendedPlaceWidget(place: places[index]);
                }),
                SizedBox(height: 80,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
