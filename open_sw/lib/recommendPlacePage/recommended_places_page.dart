import 'package:flutter/material.dart';
// common_widgets 임포트
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
// 추천 목록 타일
import 'recommended_place_widget.dart';
// 검색 알고리즘
import 'package:open_sw/services/map_api_services.dart';
// 네이버맵
import 'package:flutter_naver_map/flutter_naver_map.dart';

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
    required this.activity,
  });

  @override
  State<RecommendedPlacesPage> createState() => _RecommendedPlacesPageState();
}

class _RecommendedPlacesPageState extends State<RecommendedPlacesPage> {
  List<Map<String, String>> places = [];
  NaverMapController? _mapController;
  NCameraPosition? _initialPosition;

  bool _mapReady = false;

  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0;

  @override
  void initState() {
    int pastIndex;
    super.initState();
    _initialPosition = NCameraPosition(
      target: NLatLng(widget.lat, widget.lng),
      zoom: 13,
    );
    searchPlaces();
    _pageController.addListener(() {
      final page = _pageController.page;
      if (page != null && page.round() != _currentIndex) {
        pastIndex = _currentIndex;
        setState(() {
          _currentIndex = page.round();
        });
        if(_currentIndex != pastIndex){
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
        query: widget.activity,
      );

      if (nearby.isNotEmpty) {
        final first = nearby[0];
        final lat = double.parse(first['y']!);
        final lng = double.parse(first['x']!);

        setState(() {
          places = nearby;
        });

        // 지도가 준비되어 있으면 바로 마커 추가 및 카메라 이동
        if (_mapReady && _mapController != null) {
          addMarkers();
          _mapController!.updateCamera(NCameraUpdate.withParams(
            target: NLatLng(lat, lng),
            zoom: 14,
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('장소 검색 실패: $e')),
      );
    }
  }

  void addMarkers() {
    if (_mapController == null) return;

    final markers = places.asMap().entries.map((entry) {
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
      NCameraUpdate.withParams(
        target: NLatLng(lat, lng),
        zoom: 14,
      ),
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
                  _mapController!.updateCamera(NCameraUpdate.withParams(
                    target: NLatLng(lat, lng),
                    zoom: 14,
                  ));
                }
              },
              options: NaverMapViewOptions(
                initialCameraPosition: _initialPosition!,
                rotationGesturesEnable: false,
                zoomGesturesEnable: false,
                tiltGesturesEnable: false,
                scrollGesturesEnable: true,
                stopGesturesEnable: true,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 240,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: places.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return RecommendedPlaceWidget(place: places[index]);
                        }
                    ),
                  ),
                  SizedBox(height: 32,),
                  bottomNavigationBarSpacer(context),
                ],
              ),
            )
          ],
        )
    );
  }
}
