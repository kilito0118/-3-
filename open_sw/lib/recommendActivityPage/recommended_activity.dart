import 'package:flutter/material.dart';
import 'package:open_sw/recommendPage/recommended_places_screen.dart';
import 'package:open_sw/recommendPlacePage/set_place_page.dart';

class RecommendedActivity extends StatefulWidget {
  final String activity;

  const RecommendedActivity({super.key, required this.activity});

  @override
  State<RecommendedActivity> createState() => _RecommendedActivityState();
}

class _RecommendedActivityState extends State<RecommendedActivity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 활동명
          Text(
            widget.activity,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          // 장소 검색버 튼
          TextButton(
            // 함수 구현 필요함
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SetPlacePage(
                        activity: widget.activity,
                      ),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.all(0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '장소 검색하기',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                SizedBox(width: 4),
                Icon(Icons.search, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
