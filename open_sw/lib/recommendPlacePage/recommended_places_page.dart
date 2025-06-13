import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// common_widgets 임포트
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
// 추천 목록 타일
import 'recommended_place_widget.dart';
// 검색 알고리즘
import 'package:open_sw/services/map_api_services.dart';
// 네이버맵
import 'package:flutter_naver_map/flutter_naver_map.dart';
// 활동 정보
import 'package:open_sw/services/activity_info.dart';

class RecommendedPlacesPage extends StatefulWidget {
  final String posName;
  final double lat;
  final double lng;
  final int type;
  final String groupId;
  final String activity;

  const RecommendedPlacesPage({
    super.key,
    required this.posName,
    required this.lat,
    required this.lng,
    required this.type,
    required this.groupId,
    required this.activity,
  });

  @override
  State<RecommendedPlacesPage> createState() => _RecommendedPlacesPageState();
}

final double camZoom = 17.0;

class _RecommendedPlacesPageState extends State<RecommendedPlacesPage> {
  List<Map<String, String>> places = [];

  // 네이버맵을 사용하지 않는 경우를 대비한 예외 처리

  NaverMapController? _mapController;
  NCameraPosition? _initialPosition;

  bool _mapReady = false;

  late Map<String, dynamic> selectedAct;

  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0;

  @override
  void initState() {
    int pastIndex;
    super.initState();

    // 네이버맵을 사용하지 않는 경우를 대비한 예외 처리

    _initialPosition = NCameraPosition(
      target: NLatLng(widget.lat, widget.lng),
      zoom: 13,
    );
    selectedAct = activityList[widget.type];
    searchPlaces();
    _pageController.addListener(() {
      final page = _pageController.page;
      if (page != null && page.round() != _currentIndex) {
        pastIndex = _currentIndex;
        setState(() {
          _currentIndex = page.round();
        });
        if (_currentIndex != pastIndex) {
          goToMarker();
        }
      }
    });
  }

  void searchPlaces() async {
    try {
      final nearby = await findNearbyPlaces(
        latitude: widget.lat,
        longitude: widget.lng,
        keywords: selectedAct['keywords'],
        categoryCodes: selectedAct['categoryCodes'],
      );

      if (nearby.isNotEmpty) {
        final first = nearby[0];
        final lat = double.parse(first['y']!);
        final lng = double.parse(first['x']!);

        setState(() {
          places = nearby;
        });
        //print(nearby);
        // 지도가 준비되어 있으면 바로 마커 추가 및 카메라 이동
        if (_mapReady && _mapController != null) {
          addMarkers();
          _mapController!.updateCamera(
            NCameraUpdate.withParams(target: NLatLng(lat, lng), zoom: camZoom),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('장소 검색 실패: $e')));
      }
    }
  }

  void addMarkers() {
    if (_mapController == null) return;

    final markers =
        places.asMap().entries.map((entry) {
          final idx = entry.key;
          final place = entry.value;
          return NMarker(
            id: 'marker_$idx',
            position: NLatLng(
              double.parse(place['y']!),
              double.parse(place['x']!),
            ),
            caption: NOverlayCaption(text: place['name'] ?? '이름 없음'),
          );
        }).toSet();

    _mapController!.clearOverlays();
    _mapController!.addOverlayAll(markers);
  }

  void goToMarker() {
    if (places.isEmpty || _mapController == null) return;

    final target = places[_currentIndex];
    final lat = double.parse(target['y']!);
    final lng = double.parse(target['x']!);

    _mapController!.updateCamera(
      NCameraUpdate.withParams(target: NLatLng(lat, lng), zoom: camZoom),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: defaultAppBar(),
      body: Stack(
        children: [
          NaverMap(
            onMapReady: (controller) {
              _mapController = controller;
              _mapReady = true;

              // 장소가 이미 검색되었으면 마커 추가
              if (places.isNotEmpty) {
                addMarkers();

                final lat = double.parse(places[_currentIndex]['y']!);
                final lng = double.parse(places[_currentIndex]['x']!);
                _mapController!.updateCamera(
                  NCameraUpdate.withParams(
                    target: NLatLng(lat, lng),
                    zoom: camZoom,
                  ),
                );
              }
            },
            options: NaverMapViewOptions(
              mapType: NMapType.basic,
              liteModeEnable: true,
              initialCameraPosition: _initialPosition!,
              rotationGesturesEnable: false,
              zoomGesturesEnable: true,
              tiltGesturesEnable: false,
              scrollGesturesEnable: true,
              stopGesturesEnable: true,
            ),
          ),

          Column(
            children: [
              topAppBarSpacer(context),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(paddingSmall),
                  child: blurredBox(
                    child: Text(
                      textAlign: TextAlign.center,
                      '"${widget.posName}" 주변 장소들이에요',
                      style: contentsNormal(),
                    ),
                    topRad: 20,
                    bottomRad: 20,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 340,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: places.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return RecommendedPlaceWidget(
                        place: places[index],
                        type: widget.type,
                        groupId: widget.groupId,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
