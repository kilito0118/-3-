import 'package:geolocator/geolocator.dart';

Future<Map<String, dynamic>> getCurrentLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        'success': false,
        'error': '위치 서비스가 꺼져 있습니다.'
      };
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          'success': false,
          'error': '위치 권한이 거부되었습니다.'
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        'success': false,
        'error': '위치 권한이 영구적으로 거부되었습니다.'
      };
    }

    // 정확도가 high이면 대략 첫실행기준 6초 이상, 이후 실행에서는 3~5초정도 걸리는것 같습니다.
    // medium 혹은 low가 적절해 보이나 애뮬레이터 상에서는 medium이 오히려 high보다 오래걸리는 상황이 있어서 high로 설정해두었습니다.
    // low는 첫실행 제외하고 거의 1초만에 로딩될정도로 빠르지만 좀 덜 정확해요.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return {
      'success': true,
      'lat': position.latitude,
      'lng': position.longitude,
    };
  } catch (e) {
    return {
      'success': false,
      'error': '위치 정보를 가져오는 중 오류 발생: $e'
    };
  }
}