// json 파일 변환
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final int maxSize = 20;

// 검색 대상만 받아 장소의 리스트 및 x, y 반환
Future<List<Map<String, String>>> findPlaces(String query) async {
  // api 키 로딩 및 예외 처리
  final apiKey = dotenv.env['KAKAO_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('Kakao API Key not found in .env file');
  }

  // 검색 api 요청
  final url = Uri.parse(
    'https://dapi.kakao.com/v2/local/search/keyword.json',
  ).replace(queryParameters: {'query': query});
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
      if (x != null && x != '' && y != null && y != '') {
        results.add({
          'name': doc['place_name'] ?? '',
          'address': doc['road_address_name'] ?? doc['address_name'] ?? '',
          'x': x,
          'y': y,
        });
      }
    }

    return results;
  } else {
    // 에러
    throw Exception('Failed to fetch data: ${response.statusCode}');
  }
}

// 쿼리 집합과 카테고리 집합을 받아 리스트 반환(거리기준 정렬 및 최대 20개 반환)
Future<List<Map<String, String>>> findNearbyPlaces({
  required double latitude,
  required double longitude,
  required List<String> keywords,
  required List<String> categoryCodes,
  bool removeDuplicates = true,
}) async {
  final Set<String> seenIds = {};
  final List<Map<String, String>> allResults = [];

  // 키워드 집합 검색
  for (String keyword_and_category in keywords) {
    final parts = keyword_and_category.split('/');
    final String keyword;
    final String categoryfilter;

    if (parts.length >= 2) {
      keyword = parts[0].trim();
      categoryfilter = parts[1].trim();
    } else {
      keyword = parts[0].trim();
      categoryfilter = '';
    }

    try {
      final results = await findNearbyPlaces_keyword(
        latitude: latitude,
        longitude: longitude,
        keyword: keyword,
        categoryFilter: categoryfilter,
      );

      for (final place in results) {
        if (!removeDuplicates || !seenIds.contains(place['id'])) {
          allResults.add(place);
          seenIds.add(place['id'] ?? '');
        }
      }
    } catch (e) {
      print('Error while fetching "$keyword": $e');
    }
  }

  // 카테고리 집합 검색
  for (String categoryCode in categoryCodes) {
    try {
      final results = await findNearbyPlaces_category(
        latitude: latitude,
        longitude: longitude,
        categoryCode: categoryCode,
      );

      for (final place in results) {
        if (!removeDuplicates || !seenIds.contains(place['id'])) {
          allResults.add(place);
          seenIds.add(place['id'] ?? '');
        }
      }
    } catch (e) {
      print('Error while fetching "$categoryCode": $e');
    }
  }

  // 거리 기준 오름차순 정렬
  allResults.sort((a, b) {
    final int distA = int.tryParse(a['distance'] ?? '') ?? 999999;
    final int distB = int.tryParse(b['distance'] ?? '') ?? 999999;
    return distA.compareTo(distB);
  });

  // 최대 maxResults개까지만 반환
  return allResults.take(maxSize).toList();
}

// 키워드를 받아 기준좌표 주변의 장소탐색
Future<List<Map<String, String>>> findNearbyPlaces_keyword({
  required double latitude,
  required double longitude,
  required String keyword,
  required String categoryFilter,
  int resultSize = 15,
}) async {
  // api 키 로딩 및 예외 처리
  final apiKey = dotenv.env['KAKAO_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('Kakao API Key not found in .env file');
  }

  final url = Uri.parse(
    'https://dapi.kakao.com/v2/local/search/keyword.json',
  ).replace(
    queryParameters: {
      'query': keyword,
      'x': longitude.toString(),
      'y': latitude.toString(),
      'radius': '1000',
      'size': resultSize.toString(),
      'sort': 'distance',
    },
  );

  // 결과
  final response = await http.get(
    url,
    headers: {'Authorization': 'KakaoAK $apiKey'},
  );

  // 응답 처리 및 반환
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final List<Map<String, String>> results = [];

    // id, name, address, phone, x, y 로 구성
    for (var doc in json['documents']) {
      final String categoryName = doc['category_name'] ?? '';

      if (categoryFilter.trim().isNotEmpty &&
          !categoryName.contains(categoryFilter)) {
        print('필터링됨');
        continue;
      }

      print('필터 통과');

      results.add({
        'id': doc['id'],
        'name': doc['place_name'] ?? '',
        'address': doc['road_address_name'] ?? doc['address_name'] ?? '',
        'phone': doc['phone'] ?? '',
        'x': doc['x'] ?? '',
        'y': doc['y'] ?? '',
        'distance': doc['distance'],
      });
    }

    return results;
  } else {
    // 에러
    throw Exception('Failed to fetch data: ${response.statusCode}');
  }
}

// 카테고리를 받아 기준좌표 주변의 장소탐색
Future<List<Map<String, String>>> findNearbyPlaces_category({
  required double latitude,
  required double longitude,
  required String categoryCode,
  int resultSize = 15,
}) async {
  final apiKey = dotenv.env['KAKAO_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('Kakao API Key not found in .env file');
  }

  final url = Uri.parse(
    'https://dapi.kakao.com/v2/local/search/category.json',
  ).replace(
    queryParameters: {
      'category_group_code': categoryCode,
      'x': longitude.toString(),
      'y': latitude.toString(),
      'radius': '1000',
      'size': resultSize.toString(),
      'sort': 'distance',
    },
  );

  final response = await http.get(
    url,
    headers: {'Authorization': 'KakaoAK $apiKey'},
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final List<Map<String, String>> results = [];

    for (var doc in json['documents']) {
      results.add({
        'id': doc['id'],
        'name': doc['place_name'] ?? '',
        'address': doc['road_address_name'] ?? doc['address_name'] ?? '',
        'phone': doc['phone'] ?? '',
        'x': doc['x'] ?? '',
        'y': doc['y'] ?? '',
        'distance': doc['distance'] ?? '',
      });
    }

    return results;
  } else {
    throw Exception('Failed to fetch data: ${response.statusCode}');
  }
}

// 장소의 id를 링크로 변환
String getPlaceUrl(String id) {
  return 'https://place.map.kakao.com/$id';
}
