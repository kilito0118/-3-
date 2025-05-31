import 'package:flutter/material.dart';
import 'dart:math';
import 'recommended_activity.dart';

class RecommendActPage extends StatefulWidget {
  const RecommendActPage({super.key});

  @override
  State<RecommendActPage> createState() => _RecommendActPageState();
}

class _RecommendActPageState extends State<RecommendActPage> {

  // 임시 배열 (이 리스트에 추천 목록들을 전부 받아와야함)
  final List<String> recommendedList = [
    '볼링장',
    '풋살장',
    '미술관',
    'pc방',
    '카페',
    '클럽',
    '보드게임',
    '공원',
    '술집',
    '도서관'
  ];
  
  // 추천해줄 리스트
  late List<String> reducedList;
  
  // 받아온 리스트에서 5개만 뽑아 추천해줄 리스트에 저장
  List<T> RandList<T>(List<T> list, int count) {
    if(count > list.length){
      count = list.length;
    }
    List<T> copy = List.from(list);
    copy.shuffle(Random());
    return copy.sublist(0, count);
  }
  
  // 시작시 리스트 추천 리스트 생성
  @override
  void initState() {
    super.initState();
    reducedList = RandList(recommendedList, 5);
  }
  
  // 새로고침 버튼을 누르면 다시 추천리슽트 생성
  void refreshList() {
    setState(() {
      reducedList = RandList(recommendedList, 5);
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 뒤로가기 버튼은 AppBar에 구현
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
              Icons.arrow_back,
              color:Colors.black,
              size: 32,
          ),
        ),
      ),
      body: Container(
        // 배경 테마 설정
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(left: 26, right: 26),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF2F2F2), Color(0xFFD9D9D9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80,),

              // title
              Text(
                '이런 활동, 어떠신가요?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 40,),

              // 목록 출력
              ...List.generate(reducedList.length, (index) {
                return RecommendedActivity(activity: reducedList[index]);
              }),
              SizedBox(height: 10,),

              // 새로 고침 버튼
              TextButton(
                // 리스트 새로고침 함수
                onPressed: refreshList,
                style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    padding: EdgeInsets.all(0)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '새로 고침',
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                    SizedBox(width: 4,),
                    Icon(
                      Icons.refresh,
                      size: 20,
                    ),
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
