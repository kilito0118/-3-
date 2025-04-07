import 'package:flutter/material.dart';

class QuestionsPage extends StatefulWidget {
  final int number;
  final double progress;
  const QuestionsPage({
    super.key,
    required this.number,
    required this.progress,
  });

  @override
  QuestionsPageState createState() => QuestionsPageState();
}

class QuestionsPageState extends State<QuestionsPage> {
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.2,
              left: screenWidth * 0.15,
              right: screenWidth * 0.15,
              bottom: 80,
            ),
            child: Column(
              children: [
                Text('질문 ${widget.number}'),

                LinearProgressIndicator(
                  value: widget.progress, // 70% 진행
                  backgroundColor: Colors.grey[300], // 배경색
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue,
                  ), // 진행 색상
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
