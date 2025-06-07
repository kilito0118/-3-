import 'package:flutter/material.dart';
import 'package:open_sw/recommendActivityPage/recommend_act_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

//void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: SearchButton()))));

class SearchButton extends StatefulWidget {
  final String groupId;

  const SearchButton({super.key, required this.groupId});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {

  double _scale = 1.0;
  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }
  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }
  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
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
            await firestore.collection('groups').doc(widget.groupId).get();
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
              print(widget.groupId);
              try {
                DocumentSnapshot userDoc =
                await firestore.collection('users').doc(uid).get();
                if (userDoc.exists) {
                  Map<String, dynamic> userData =
                  userDoc.data() as Map<String, dynamic>;
                  int number = userData['number'] ?? 0;
                  rowNumbers.add(number);
                }
                //print(rowNumbers);
              } catch (e) {
                print('Error fetching user data for uid $uid: $e');
              }
            }
          } catch (e) {
            print('Error fetching group data: $e');
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecommendActPage(rowNumbers: rowNumbers),
            ),
          );
        },
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          child: AnimatedGradientBox(
              shadowColor1: themeRed,
              shadowColor2: themeLightOrange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('맞춤 활동 검색하기',
                    style: contentsNormal(
                        color: Colors.black.withAlpha(180),
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  spacingBox_mini(),
                  Icon(Icons.search)
                ],
              )
          ),
        )
      ),
    );
  }
}