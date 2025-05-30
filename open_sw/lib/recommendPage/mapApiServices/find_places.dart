// json 파일 변환
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// 검색 대상만 받아 장소의 리스트 및 x, y 반환
Future<List<Map<String, String>>> findPlaces(String query) async {
  // api 키 로딩 및 예외 처리
  final apiKey = dotenv.env['KAKAO_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('Kakao API Key not found in .env file');
  }

  // 검색 api 요청
  final url = Uri.parse('https://dapi.kakao.com/v2/local/search/keyword.json')
      .replace(queryParameters: {'query': query,});
  // 결과
  final response = await http.get(
    url,
    headers: {'Authorization': 'KakaoAK $apiKey'},
  );

  // 응답 처리 및 반환
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final List<Map<String, String>> results = [];

    // 이름, 주소, x, y 리스트 반환
    // x, y가 없는 장소는 반환 안함
    for (var doc in json['documents']) {
      final x = doc['x'];
      final y = doc['y'];
      if(x != null && x != '' && y != null && y != ''){
        results.add({
          'name': doc['place_name'] ?? '',
          'address': doc['road_address_name'] ?? doc['address_name'] ?? '',
          'x': x,
          'y': y,
        });
      }
    }

    return results;
  }
  else {
    // 에러
    throw Exception('Failed to fetch data: ${response.statusCode}');
  }
}

// x, j 좌표 및 검색 대상을 받아 장소의 리스트 반환
Future<List<Map<String, String>>> findNearbyPlaces({
  required double latitude,
  required double longitude,
  required String query,
}) async {
  // api 키 로딩 및 예외 처리
  final apiKey = dotenv.env['KAKAO_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('Kakao API Key not found in .env file');
  }

  // 검색 api 요청
  final url = Uri.parse('https://dapi.kakao.com/v2/local/search/keyword.json')
      .replace(queryParameters: {
    'query': query,
    'x': longitude.toString(),
    'y': latitude.toString(),
    'radius': '1000',
    'size': '15',
    'sort': 'distance',
  });
  // 결과
  final response = await http.get(
    url,
    headers: {'Authorization': 'KakaoAK $apiKey'},
  );

  // 응답 처리 및 반환
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final List<Map<String, String>> results = [];

    // id, name, address, phone 으로 구성
    for (var doc in json['documents']) {
      results.add({
        'id': doc['id'],
        'name': doc['place_name'] ?? '',
        'address': doc['road_address_name'] ?? doc['address_name'] ?? '',
        'phone': doc['phone'] ?? '',
      });
    }

    return results;
  }
  else {
    // 에러
    throw Exception('Failed to fetch data: ${response.statusCode}');
  }
}

// 장소의 id를 링크로 변환
String getPlaceUrl(String id) {
  return 'https://place.map.kakao.com/$id';
}