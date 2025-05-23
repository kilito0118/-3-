import 'package:flutter/material.dart';

class Activity {
  final String type;
  final String place;
  final String date;

  Activity({
    required this.type,
    required this.place,
    required this.date
  });
}

class ActivityBox extends StatefulWidget {
  final Activity recentAct;

  const ActivityBox({
    super.key,
    required this.recentAct,
  });

  @override
  State<ActivityBox> createState() => _ActivityBoxState();
}

class _ActivityBoxState extends State<ActivityBox> {
  bool liked = false;
  bool disliked = false;
  
  // 좋아요 버튼을 눌렀을 때 실행되는 함수입니다
  void like () {
    setState(() {
      liked = !liked;
      if(liked){
        disliked = false;
      }
    });
  }

  // 싫어요 버튼을 눌렀을 때 실행되는 함수입니다
  void dislike () {
    setState(() {
      disliked = !disliked;
      if(disliked){
        liked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 10,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 활동 일자
          Text(
            widget.recentAct.date,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 10,),

          // 활동 이름 및 장소
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 활동명
                Text(
                  widget.recentAct.type,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                // 활동 장소
                Text(
                  widget.recentAct.place,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10,),

          // 활동 평가
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 싫어요 버튼
              TextButton(
                onPressed: dislike,
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF6283E9),
                  padding: EdgeInsets.all(0)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      disliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                      size: 32,
                    ),
                    SizedBox(width: 4,),
                    Text(
                      '나빴어요',
                      style: TextStyle(
                        color: const Color(0xFF6283E9),
                        fontSize: 14
                      ),
                    )
                  ],
                ),
              ),
              // 좋아요 버튼
              TextButton(
                onPressed: like,
                style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFE75F5F),
                    padding: EdgeInsets.all(0)
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '좋았어요',
                      style: TextStyle(
                          color: const Color(0xFFE75F5F),
                          fontSize: 14
                      ),
                    ),
                    SizedBox(width: 4,),
                    Icon(
                      liked ? Icons.favorite : Icons.favorite_outline,
                      size: 32,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
