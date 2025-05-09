// recommended_places_page.dart
import 'package:flutter/material.dart';

class RecommendedPlacesScreen extends StatelessWidget {
  const RecommendedPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RecommendPage();
  }
}

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double scaleWidth;
  static late double scaleHeight;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    scaleWidth = screenWidth / 360.0;
    scaleHeight = screenHeight / 800.0;
  }

  static double w(double value) => value * scaleWidth;
  static double h(double value) => value * scaleHeight;
}

class RecommendPage extends StatelessWidget {
  const RecommendPage({super.key});

  Widget buildStarRow(int filledStars) {
    return Row(
      children: List.generate(3, (index) {
        return Icon(
          Icons.star,
          color: index < filledStars ? Colors.orange : Colors.grey,
          size: SizeConfig.w(16),
        );
      }),
    );
  }

  Widget buildPlaceCard() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.h(10)),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(16),
        vertical: SizeConfig.h(16),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.w(20)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: SizeConfig.w(6)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '장소명',
                style: TextStyle(
                  fontSize: SizeConfig.w(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.h(4)),
              Row(
                children: [
                  Text('만족도', style: TextStyle(fontSize: SizeConfig.w(14))),
                  SizedBox(width: SizeConfig.w(8)),
                  buildStarRow(2),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '상세 주소',
                style: TextStyle(
                  fontSize: SizeConfig.w(13),
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: SizeConfig.h(8)),
              Text(
                '자세히 보기',
                style: TextStyle(
                  fontSize: SizeConfig.w(13),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(26)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.h(24)),
            Row(
              children: [
                Transform.translate(
                  offset: Offset(-SizeConfig.w(18), -SizeConfig.h(8)),
                  child: Icon(Icons.arrow_back_ios_new, size: SizeConfig.w(28)),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.h(26)),
            Center(
              child: Text(
                'Activity_title',
                style: TextStyle(
                  fontSize: SizeConfig.w(32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.h(40)),
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.w(12)),
              child: Text(
                '추천장소',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: SizeConfig.w(14),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.h(10)),
            buildPlaceCard(),
            buildPlaceCard(),
            buildPlaceCard(),
          ],
        ),
      ),
    );
  }
}
