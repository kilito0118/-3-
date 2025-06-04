import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/place_search_widget.dart';

//void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: SearchButton()))));

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 26),
      child: Container(
        height: 44,

        decoration: BoxDecoration(
          color: Colors.transparent, // 바깥 배경
          borderRadius: BorderRadius.circular(48),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              //backgroundColor: Colors.transparent,
              //barrierColor: Colors.transparent,
              useSafeArea: true,
              isScrollControlled: true,

              backgroundColor: Colors.transparent,
              constraints: BoxConstraints(
                minHeight: 300,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: 320,
              ),
              elevation: 800,

              builder: (context) {
                return PlaceSearchWidget(); // PlaceSearchWidget로 변경
                // 원하는 위젯 추가
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                "찾아보기",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
