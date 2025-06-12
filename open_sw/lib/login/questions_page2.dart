import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:open_sw/mainPage/home_screen.dart';

final Map<int, String> activityNumberMap =
    (() {
      final map = <int, String>{};
      int i = 1;
      final activities = [
        // 감성충전러
        "전시회 관람(미술, 사진, 건축, 디자인 등)",
        "박물관 관람",
        "음악연주회 관람(클래식, 오페라 등)",
        "전통예술공연 관람(국악, 민속놀이 등)",
        "연극공연 관람(뮤지컬 포함)",
        "무용공연 관람",
        "영화관람",
        "연예공연 관람(쇼, 콘서트, 마술 쇼 등)", //8
        // 감성 크리에이터
        "문학행사참여",
        "글짓기/독서토론",
        "미술활동(그림, 서예, 조각, 디자인, 도예, 만화 등)",
        "악기연주/노래교실",
        "전통예술 배우기(사물놀이, 줄타기 등)",
        "사진촬영(디지털카메라 포함)",
        "춤/무용(발레, 한국무용, 현대무용, 방송댄스, 스트릿댄스, 비보잉 등)",

        // 스포츠 팬클럽장
        "스포츠 경기 직접관람- 경기장방문관람(축구, 야구, 농구, 배구 등)",
        "스포츠 경기 간접관람- TV, DMB를 통한관람(축구, 야구, 농구, 배구 등)",
        "격투 스포츠 경기관람(태권도, 유도, 합기도, 검도, 권투 등)",
        "온라인게임 경기관람(e-스포츠 경기 포함)",

        // 근손실 거부러
        "농구, 배구, 야구, 축구, 족구",
        "테니스, 스쿼시",
        "당구/포켓볼",
        "볼링, 탁구",
        "골프",
        "수영",
        "윈드서핑, 수상스키, 스킨스쿠버다이빙, 래프팅, 요트",
        "스노보드, 스키 등",
        "아이스스케이트, 아이스하키 등",
        "헬스(보디빌딩)/에어로빅",
        "요가/필라테스/태보",
        "배드민턴/줄넘기/맨손체조/스트레칭/훌라후프",
        "조깅/속보/육상",
        "격투 스포츠(태권도, 유도, 합기도, 검도, 권투 등)",
        "댄스스포츠(탱고, 왈츠, 자이브 맘보, 폴카, 차차차 등)",
        "사이클링/산악자전거",
        "인라인스케이트",
        "승마/암벽등반/철인3종경기/서바이벌",

        // 자연愛 탐험가
        "문화유적 방문(고궁, 절, 유적지 등등)",
        "자연 풍경 관람 및 명상",
        "삼림욕",
        "국내캠핑",
        "해외여행",
        "소풍/야유회",
        "온천/해수욕",
        "유람선 타기",
        "놀이공원/테마파크/동물원/식물원 방문",
        "지역축제 참가",
        "자동차 드라이브",

        // 취미 부자
        "수집 활동(스크랩 포함)",
        "생활공예(십자수, 비즈공예 D.I.Y, 꽃꽃이 등)",
        "요리/다도",
        "반려동물 돌보기",
        "노래방",
        "인테리어(집, 자동차 등)",
        "등산",
        "낚시",
        "홈페이지/블로그 관리",
        "인터넷/SNS/영상편집",
        "게임(온라인/모바일/콘솔게임 등)",
        "보드게임/퍼즐/큐브 맞추기",
        "바둑/체스/장기",
        "겜블(경마, 카지노, 고스톱, 마작 등)/복권 구입",
        "쇼핑/외식",
        "음주",
        "독서/웹소설/신문잡지",
        "만화/웹툰 보기",
        "미용/피부/헤어/네일/마사지",
        "공부/자격증/학원",
        "테마카페 체험(방탈출, VR, 낚시카페 등)",
        "원예(화단, 화분 가꾸기 등)",

        // 집콕 장인
        "산책/걷기",
        "목욕/사우나/찜질방",
        "낮잠",
        "TV 시청",
        "모바일/OTT/VOD/동영상상 시청",
        "라디오/팟캐스트 청취",
        "음악 감상",
        "신문/잡지 보기",
        "아무것도 안 하기",

        // 사교 활동 만렙러
        "사회봉사활동",
        "종교활동",
        "클럽/나이트/디스코",
        "가족 및 친지 방문",
        "잡담/통화/문자/메신저",
        "계모임/동창회/사교모임/파티",
        "친구만남/이성교제/미팅/소개팅",
        "동호회 모임",
        "기타 여가활동",
        "독서/만화책(웹툰)보기",
        "이성교제(데이트)/미팅/소개팅",
        "친구만남/동호회 모임",
      ];
      for (final activity in activities) {
        map[i++] = activity;
      }
      return map;
    })();

class QuestionsPage2 extends StatefulWidget {
  final List<int> selectedActivityNumbers;

  const QuestionsPage2({super.key, required this.selectedActivityNumbers});

  @override
  State<QuestionsPage2> createState() => _QuestionsPage2State();
}

Future<int> getCollectionCount(String collectionName) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection(collectionName).get();

  return snapshot.docs.length;
}

List<Map<String, dynamic>> createActivityListFromSet(Set<int> intSet) {
  return intSet.map((e) => {"activity": e, "like": 6.0, "count": 5}).toList();
}

class _QuestionsPage2State extends State<QuestionsPage2> {
  String result = '';
  bool isLoading = false;

  Future<void> sendJsonToFlask(Map<String, Object> data) async {
    const url =
        'http://43.203.239.150:8000/user/create'; // Flask 서버 주소 (필요시 수정)
    debugPrint("Sending data to Flask: $data");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      // if (response.statusCode == 200) {
      //   final json = jsonDecode(response.body);
      //   setState(() {
      //     result = "추천 활동: ${json['recommended_activities']}";
      //   });
      // } else {
      //   setState(() {
      //     result = '서버 응답 오류: ${response.statusCode}';
      //   });
      // }

      debugPrint("Response status: ${jsonDecode(response.body)["row_index"]}");
      final data2 = jsonDecode(response.body);
      number = int.parse(data2["row_index"].toString());

      if (response.statusCode != 200) {
        debugPrint("오류 발생: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  int number = 10045; // 초기값 설정
  List<int> currentActivities = [];
  Set<int> selectedActivities = {};

  @override
  void initState() {
    super.initState();
    _refreshActivities();
  }

  Future<List<String>> updateLikes(List likes) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
    Map<String, dynamic> data1 = {
      "gender": userData["gender"] == "남" ? 1 : 2, // 1: 남자, 2: 여자
      "age": userData["age"],
      "liked_activities": likes,
    };
    await sendJsonToFlask(
      data1.map((key, value) => MapEntry(key, value as Object)),
    );

    //int number = await getCollectionCount("users") + 10046;
    List<Map<String, dynamic>> data = createActivityListFromSet(
      likes.toSet().cast<int>(),
    );
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      "likes": data,
      "number": number,
    });

    debugPrint("Data1: $data1");
    debugPrint("Likes: $likes");

    return [];
  }

  void _refreshActivities() {
    final random = Random();

    // 선택된 활동은 그대로 유지
    final selectedList = selectedActivities.toList();

    // 전체 후보 중 선택된 활동을 제외한 나머지
    final remainingCandidates =
        widget.selectedActivityNumbers
            // ignore: avoid_types_as_parameter_names
            .where((num) => !selectedActivities.contains(num))
            .toList();

    // 남은 후보 셔플
    remainingCandidates.shuffle(random);

    // 선택된 활동과 섞인 나머지 활동 합치기 (최대 16개)
    currentActivities = [
      ...selectedList,
      ...remainingCandidates.take(16 - selectedList.length),
    ];

    // 선택한 활동은 그대로 유지하므로 selectedActivities.clear()는 제거
    setState(() {});
  }

  void _toggleSelection(int number) {
    setState(() {
      if (selectedActivities.contains(number)) {
        selectedActivities.remove(number);
      } else {
        if (selectedActivities.length < 5) {
          selectedActivities.add(number);
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
          colors: [Colors.white, const Color(0x9fFAF6F6)],
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
                                activityNumberMap[activity] ?? '',
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
                                // 다음 페이지로 이동
                                updateLikes(selectedActivities.toList());
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                  (route) => false,
                                );
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
