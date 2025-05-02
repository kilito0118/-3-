import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class NaverDirectionsButton extends StatelessWidget {
  // 목적지 좌표 (예시: 서울 시청)
  final double destLat = 37.5665;
  final double destLng = 126.9780;

  const NaverDirectionsButton({super.key});

  Future<void> openNaverDirections(BuildContext context) async {
    // 1. 현재 위치 권한 요청 및 위치 가져오기
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('위치 권한이 필요합니다.')));
      return;
    }
    print(1);

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } on LocationServiceDisabledException {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('위치 서비스가 비활성화되어 있습니다.')));
      return;
    } on PermissionDeniedException {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('위치 권한이 거부되었습니다.')));
      return;
    }

    // 2. 네이버 지도 앱 설치 여부 확인
    bool isNaverMapInstalled =
        await MapLauncher.isMapAvailable(MapType.naver) ?? false;

    if (!isNaverMapInstalled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('네이버 지도 앱이 설치되어 있지 않습니다.')));

      var url = Uri.parse('https://flutter.dev');
      if (await canLaunchUrl(url)) {
        // 외부 브라우저로 열기
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
      return;
    }

    // 3. 네이버 지도 길찾기 실행
    await MapLauncher.showDirections(
      mapType: MapType.naver,
      destination: Coords(destLat, destLng),
      destinationTitle: '목적지',
      origin: Coords(position.latitude, position.longitude),
      originTitle: '현재 위치',
      directionsMode: DirectionsMode.driving,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('네이버 지도 길찾기'),
      onPressed: () => openNaverDirections(context),
    );
  }
}
