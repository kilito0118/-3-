/*
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openNaverDirections({
  required BuildContext context,
  required double destLat,
  required double destLng,
  required String destName,
}) async {
  try {
    // 위치 권한 요청 및 현재 위치 가져오기
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('위치 권한이 필요합니다.')));
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // 네이버 지도 앱 설치 여부 확인
    final isNaverInstalled = await MapLauncher.isMapAvailable(MapType.naver);

    if (isNaverInstalled == true) {
      // 네이버 지도 앱으로 길찾기 실행
      await MapLauncher.showDirections(
        mapType: MapType.naver,
        destination: Coords(destLat, destLng),
        destinationTitle: destName,
        origin: Coords(position.latitude, position.longitude),
        originTitle: '현재 위치',
        directionsMode: DirectionsMode.driving,
      );
    } else {
      // 네이버 지도 앱이 없으면 웹 브라우저로 길찾기 연결
      final dnameEncoded = Uri.encodeComponent(destName);
      final webUrl =
          'https://m.map.naver.com/route/public/car?slat=${position.latitude}&slng=${position.longitude}&sname=%ED%98%84%EC%9E%AC%EC%9C%84%EC%B9%98&dlat=$destLat&dlng=$destLng&dname=$dnameEncoded';
      if (await canLaunchUrl(Uri.parse(webUrl))) {
        await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('네이버 지도 웹을 열 수 없습니다.')));
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('오류 발생: $e')));
  }
}
*/
