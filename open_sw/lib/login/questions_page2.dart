import 'package:flutter/material.dart';
import 'dart:math';

class QuestionsPage2 extends StatefulWidget {
  final List<String> selectedCategories; // 카테고리 2개

  const QuestionsPage2({super.key, required this.selectedCategories});

  @override
  State<QuestionsPage2> createState() => _QuestionsPage2State();
}

class _QuestionsPage2State extends State<QuestionsPage2> {
  // 선택 리스트 예시
  final List<String> allActivities = [
    "전시회 관람(미술, 사진, 건축, 디자인 등)",
    "박물관 관람",
    "음악연주회 관람(클래식, 오페라 등)",
    "전통예술공연 관람(국악, 민속놀이 등)",
    "연극공연 관람(뮤지컬 포함)",
    "무용공연 관람",
    "영화관람",
    "연예공연 관람(쇼, 콘서트, 마술 쇼 등)",
    "문학행사참여",
    "글짓기/독서토론",
    "미술활동(그림, 서예, 조각, 디자인, 도예, 만화 등)",
    "악기연주/노래교실",
    "전통예술 배우기(사물놀이, 줄타기 등)",
    "사진촬영(디지털카메라 포함)",
    "춤/무용(발레, 한국무용, 현대무용, 방송댄스, 스트릿댄스, 비보잉 등)",
    "스포츠 경기 직접관람- 경기장방문관람(축구, 야구, 농구, 배구 등)",
    "스포츠 경기 간접관람- TV, DMB를 통한관람(축구, 야구, 농구, 배구 등)",
    "격투 스포츠 경기관람(태권도, 유도, 합기도, 검도, 권투 등)",
    "온라인게임 경기관람(e-스포츠 경기 포함)",
    "농구, 배구, 야구, 축구, 족구",
    "테니스, 스쿼시",
    "당구/포켓볼",
    "볼링, 탁구",
    "골프",
    "수영",
    "윈드서핑, 수상스키, 스킨스쿠버다이빙, 래프팅, 요트",
    "스노보드, 스키 등",
    "아이스스케이트, 아이스하키 등",
  ];

  List<String> currentActivities = [];
  Set<String> selectedActivities = {};

  @override
  void initState() {
    super.initState();
    _refreshActivities();
  }

  void _refreshActivities() {
    final random = Random();
    currentActivities = List<String>.from(allActivities)..shuffle(random);
    currentActivities = currentActivities.take(16).toList();
    selectedActivities.clear();
    setState(() {});
  }

  void _toggleSelection(String activity) {
    setState(() {
      if (selectedActivities.contains(activity)) {
        selectedActivities.remove(activity);
      } else {
        if (selectedActivities.length < 5) {
          selectedActivities.add(activity);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0x9fFAF6F6)], // 그래디언트 색상 설정
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: null,
        body: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.2,
            left: screenWidth * 0.15,
            right: screenWidth * 0.15,
            bottom: 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '선호하시는 활동을\n선택해주세요',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                '${selectedActivities.length}/5',
                style: const TextStyle(color: Color(0x66000000), fontSize: 22),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        currentActivities.map((activity) {
                          final isSelected = selectedActivities.contains(
                            activity,
                          );
                          return GestureDetector(
                            onTap: () => _toggleSelection(activity),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFFFF9933)
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                activity,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _refreshActivities,
                    child: const Text(
                      '새로고침',
                      style: TextStyle(color: Color(0x66000000)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed:
                          selectedActivities.length == 5
                              ? () {
                                // 다음 페이지로 이동 로직
                              }
                              : null,
                      label: const Text(
                        '시작하기 →',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        disabledForegroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
