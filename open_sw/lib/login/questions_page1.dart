import 'package:flutter/material.dart';
import 'package:open_sw/login/questions_page2.dart';

class QuestionsPage1 extends StatefulWidget {
  const QuestionsPage1({super.key});

  @override
  QuestionsPage1State createState() => QuestionsPage1State();
}

class QuestionsPage1State extends State<QuestionsPage1> {
  final List<String> categories = [
    '🎭 감성충전러',
    '✍️ 감성 크리에이터',
    '🏟️ 스포츠 팬클럽장',
    '🏋️ 근손실 거부러',
    '🏞️ 자연愛 탐험가',
    '🧩 취미 부자',
    '🛋️ 집콕 장인',
    '🤝 사교 활동 만렙러',
  ];
  final List<(int, int, String)> ranges = [
    (1, 8, '1'),
    (9, 15, '2'),
    (16, 19, '3'),
    (20, 37, '4'),
    (38, 48, '5'),
    (49, 70, '6'),
    (71, 79, '7'),
    (80, 91, '8'),
  ];

  Set<int> selectedIndexes = {};
  List<int> selectedActivityNumbers = [];

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        if (selectedIndexes.length < 2) {
          selectedIndexes.add(index);
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
              Text(
                '선호하시는 카테고리를\n선택해주세요',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                '${selectedIndexes.length}/2',
                style: TextStyle(color: Color(0x66000000), fontSize: 22),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    bool isSelected = selectedIndexes.contains(index);
                    return GestureDetector(
                      onTap: () => _toggleSelection(index),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color:
                                isSelected
                                    ? Color(0xffff9933)
                                    : Color(0x66000000),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              categories[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemCount: categories.length,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed:
                      selectedIndexes.length == 2
                          ? () {
                            // 다음 페이지로 이동 로직

                            selectedActivityNumbers.clear();
                            for (var index in selectedIndexes) {
                              var (start, end, _) = ranges[index];
                              selectedActivityNumbers.addAll(
                                List.generate(
                                  end - start + 1,
                                  (i) => start + i,
                                ),
                              );
                            }
                            //print(selectedActivityNumbers);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => QuestionsPage2(
                                      selectedActivityNumbers:
                                          selectedActivityNumbers,
                                    ),
                              ),
                            );
                          }
                          : null,
                  label: const Text('다음으로 →', style: TextStyle(fontSize: 16)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    disabledForegroundColor: Colors.grey,
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
