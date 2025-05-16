import 'package:flutter/material.dart';

class AddSchedulePage extends StatelessWidget {
  const AddSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: DateInputPopup(),
      ),
    );
  }
}

class DateInputPopup extends StatelessWidget {
  const DateInputPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 308,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFF2F2F2), Color(0xFFD9D9D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              '날짜 입력',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),

          const SizedBox(height: 15),
          Row(
            children: [
              _roundedBoxText('00'),
              const SizedBox(width: 8),
              const Text('월'),
              const SizedBox(width: 20),
              _roundedBoxText('00'),
              const SizedBox(width: 8),
              const Text('일'),
            ],
          ),
          const SizedBox(height: 20),
          Material(
            borderRadius: BorderRadius.circular(28),
            elevation: 4,
            child: InkWell(
              onTap: () {
                // 버튼 클릭 시 동작
              },
              borderRadius: BorderRadius.circular(28),
              child: Ink(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA500), Color(0xFFFF6A00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Center(
                  child: Text(
                    '추가하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _roundedBoxText(String text) {
    return Container(
      width: 54,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
