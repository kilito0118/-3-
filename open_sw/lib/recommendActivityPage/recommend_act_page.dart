import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'recommended_activity.dart';

//const String flaskUrl = 'http://127.0.0.1:5000/group/recommendations';
// Flask 서버 주소 (필요시 수정)
const String flaskUrl = 'http://43.203.239.150:8000/group/recommendations';

class RecommendActPage extends StatefulWidget {
  final List<int> rowNumbers;

  const RecommendActPage({super.key, required this.rowNumbers});

  @override
  State<RecommendActPage> createState() => _RecommendActPageState();
}

class _RecommendActPageState extends State<RecommendActPage> {
  List<dynamic> originalActivities = []; // 서버에서 받아온 전체 리스트
  List<String> activityList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRecommendationsFromServer();
  }

  // 가중치 기반 중복 없는 샘플링
  List<T> _getUniqueWeightedSample<T>(List<T> items, int count) {
    final random = Random();
    final counts = <T, int>{};

    for (var item in items) {
      counts[item] = (counts[item] ?? 0) + 1;
    }

    final weightedList = <T>[];
    counts.forEach((key, value) {
      weightedList.addAll(List.filled(value, key));
    });

    weightedList.shuffle(random);
    final unique = <T>{};
    final result = <T>[];

    for (var item in weightedList) {
      if (!unique.contains(item)) {
        unique.add(item);
        result.add(item);
        if (result.length == count) break;
      }
    }

    return result;
  }

  // 최초 한 번만 Flask 서버에서 데이터 요청
  Future<void> fetchRecommendationsFromServer() async {
    setState(() => isLoading = true);

    final requestData = {"row_numbers": widget.rowNumbers};
    print(requestData);

    try {
      final response = await http.post(
        Uri.parse(flaskUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        originalActivities = data['recommended_activities'];

        final sample = _getUniqueWeightedSample(originalActivities, 5);

        setState(() {
          activityList = sample.map((e) => e.toString()).toList();
        });
      } else {
        print("요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("오류 발생: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 새로고침 → 이미 받은 데이터로부터 다시 샘플링
  void refreshList() {
    if (originalActivities.isNotEmpty) {
      final sample = _getUniqueWeightedSample(originalActivities, 5);
      setState(() {
        activityList = sample.map((e) => e.toString()).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 32),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 26),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF2F2F2), Color(0xFFD9D9D9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                '이런 활동, 어떠신가요?',
                style: TextStyle(color: Colors.black, fontSize: 32),
              ),
              const SizedBox(height: 40),
              if (isLoading)
                const CircularProgressIndicator()
              else if (activityList.isEmpty)
                const Text('추천 결과가 없습니다.')
              else
                ...activityList
                    .map((activity) => RecommendedActivity(activity: activity))
                    .toList(),
              const SizedBox(height: 10),
              TextButton(
                onPressed: refreshList,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  padding: EdgeInsets.zero,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('새로 고침', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 4),
                    Icon(Icons.refresh, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}