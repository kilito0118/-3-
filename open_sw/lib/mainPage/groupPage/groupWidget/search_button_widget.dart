import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/place_search_widget.dart';
import 'package:open_sw/recommendActivityPage/recommend_act_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: SearchButton()))));

class SearchButton extends StatelessWidget {
  final String groupId;
  const SearchButton({super.key, required this.groupId});

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
          onTap: () async {
            /*
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
            );*/
            List<int> rowNumbers = [];

            List<String> membersUid = [];
            String leaderUid = '';

            final FirebaseFirestore firestore = FirebaseFirestore.instance;

            try {
              DocumentSnapshot groupDoc =
              await firestore.collection('groups').doc(groupId).get();
              if (groupDoc.exists) {
                Map<String, dynamic> groupData =
                groupDoc.data() as Map<String, dynamic>;
                leaderUid = groupData['leader'] ?? '';
                membersUid = [
                  leaderUid,
                  ...groupData['members']?.map((e) => e.toString()) ?? [],
                ];
              }

              for (String uid in membersUid) {
                print(groupId);
                try {
                  DocumentSnapshot userDoc =
                  await firestore.collection('users').doc(uid).get();
                  if (userDoc.exists) {
                    Map<String, dynamic> userData =
                    userDoc.data() as Map<String, dynamic>;
                    int number = userData['number'] ?? 0;
                    rowNumbers.add(number);
                  }
                  print(rowNumbers);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RecommendActPage(rowNumbers: rowNumbers),
                    ),
                  );
                } catch (e) {
                  print('Error fetching user data for uid $uid: $e');
                }
              }
            } catch (e) {
              print('Error fetching group data: $e');
            }
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