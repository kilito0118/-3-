import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';
import 'recommended_activity.dart';

//const String flaskUrl = 'http://127.0.0.1:5000/group/recommendations';
// Flask 서버 주소 (필요시 수정)
const String flaskUrl = 'http://43.203.239.150:8000/group/recommendations';

class RecommendActPage extends StatefulWidget {
  final List<int> rowNumbers;
  final String groupId;

  const RecommendActPage({
    super.key,
    required this.rowNumbers,
    required this.groupId,
  });

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
        debugPrint("요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("오류 발생: $e");
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
      appBar: defaultAppBar(),
      backgroundColor: themePageColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topAppBarSpacer(context),
              mainTitle('좋아하실만한 활동을 \n찾았어요'),
              spacingBox(),
              subTitle('추천 활동'),
              spacingBox(),
              if (isLoading)
                const CircularProgressIndicator()
              else if (activityList.isEmpty)
                const Text('추천 결과가 없습니다.')
              else
                ...activityList.map(
                  (activity) => RecommendedActivity(
                    activity: activity,
                    groupId: widget.groupId,
                    type: int.parse(activity),
                  ),
                ),
              Center(
                child: TextButton(
                  onPressed: refreshList,
                  style: btnTransparent(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('새로 고침'),
                      spacingBoxMini(),
                      Icon(Icons.refresh, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
