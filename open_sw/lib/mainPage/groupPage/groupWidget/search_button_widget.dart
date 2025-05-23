import 'package:flutter/material.dart';

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
            print("찾아보기 클릭됨");
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
