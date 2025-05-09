import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/login/logout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_sw/useful_widget/tabel_cell_comfortable.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});
  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  DocumentSnapshot? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      setState(() {
        userInfo = doc;
        isLoading = false;
      });
      // ignore: unused_catch_clause
    } on FirebaseException catch (e) {
      //print('Firestore Error: ${e.code}');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (userInfo == null || !userInfo!.exists) {
      return Center(
        child: TextButton(
          onPressed: () => performLogout(context),
          child: Text("사용자 정보를 불러올 수 없습니다.\n누르면 로그인 화면으로 이동합니다."),
        ),
      );
    }

    final userData = userInfo!.data() as Map<String, dynamic>;
    //print(userData);
    int stoneWarRating = 1000;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user == null) {
                return TextButton(
                  onPressed: () => performLogout(context),
                  child: Text("사용자 정보를 불러올 수 없습니다."),
                );
              } else if (!user.emailVerified) {
                return TextButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('인증 메일 재전송 완료')));
                      }
                    } on FirebaseAuthException catch (e) {
                      print('재전송 실패: ${e.code}');
                      // 사용자에게 오류 알림
                    }
                  },
                  child: Text(
                    "이메일 인증을 진행해주세요!\n미인증시 매칭을 할 수 없습니다.\n\n눌러서 재전송하기.",
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Text("석전을 재미있게 즐겨주세요!");
              }
            },
          ),
          SizedBox(
            width: 800,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      userData['nickName'] ?? '이름 없음',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () {
                        if (!mounted) return;
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("보유한 스킨 목록"),
                              content: SizedBox(
                                width: double.maxFinite,
                                height:
                                    MediaQuery.of(context).size.height *
                                    0.7, // 팝업 창 높이 설정
                                child: ListView.builder(
                                  itemCount: userData['playerSkins'].length,
                                  itemBuilder: (context, index) {
                                    var log = userData['playerSkins'][index];
                                    return Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                            child: Image(
                                              image: AssetImage(
                                                ["assets/images/", log].join(),
                                              ),
                                              height: 100.0,
                                              width: 100.0,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Text(log),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("닫기"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ClipOval(
                        child: Image(
                          image: AssetImage(
                            ["assets/images/", userData["playerSkin"]].join(),
                          ),
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox(width: 800)),
              ],
            ),
          ),
          SizedBox(height: 50),
          Text("석전 레이팅 : $stoneWarRating"),
          SizedBox(
            width: screenWidth * 0.54 < 330 ? 330 : screenWidth * 0.54,
            child: Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    TableCell(child: Center(child: Text(''))),
                    TabelCellComfortable(query: "돌목"),
                    TabelCellComfortable(query: "사목"),
                    TabelCellComfortable(query: "오목"),
                    TabelCellComfortable(query: "육목"),
                  ],
                ),
                TableRow(
                  children: [
                    TabelCellComfortable(query: "레이팅"),
                    TabelCellComfortable(
                      query: '${userData["gameRatings"]["dol_mok"]["rating"]}',
                    ),
                    TabelCellComfortable(
                      query: '${userData["gameRatings"]["sa_mok"]["rating"]}',
                    ),
                    TabelCellComfortable(
                      query: '${userData["gameRatings"]["o_mok"]["rating"]}',
                    ),
                    TabelCellComfortable(
                      query: '${userData["gameRatings"]["yuk_mok"]["rating"]}',
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    if (kIsWeb) ...[
                      TabelCellComfortable(query: '승/\n패/\n승률'),
                      TabelCellComfortable(
                        query:
                            '${userData["gameCounts"]["dol_mok"]["win"]}/\n${userData["gameCounts"]["dol_mok"]["lose"]}/\n${userData["gameCounts"]["dol_mok"]["games"] == 0 ? 0 : (userData["gameCounts"]["dol_mok"]["win"] / userData["gameCounts"]["dol_mok"]["games"] * 100).toStringAsFixed(2)}%',
                      ),
                      TabelCellComfortable(
                        query:
                            '${userData["gameCounts"]["sa_mok"]["win"]}/\n${userData["gameCounts"]["sa_mok"]["lose"]}/\n${userData["gameCounts"]["sa_mok"]["games"] == 0 ? 0 : (userData["gameCounts"]["sa_mok"]["win"] / userData["gameCounts"]["sa_mok"]["games"] * 100).toStringAsFixed(2)}%',
                      ),
                      TabelCellComfortable(
                        query:
                            '${userData["gameCounts"]["o_mok"]["win"]}/\n${userData["gameCounts"]["o_mok"]["lose"]}/\n${userData["gameCounts"]["o_mok"]["games"] == 0 ? 0 : (userData["gameCounts"]["o_mok"]["win"] / userData["gameCounts"]["o_mok"]["games"] * 100).toStringAsFixed(2)}%',
                      ),
                      TabelCellComfortable(
                        query:
                            '${userData["gameCounts"]["yuk_mok"]["win"]}/\n${userData["gameCounts"]["yuk_mok"]["lose"]}/\n${userData["gameCounts"]["yuk_mok"]["games"] == 0 ? 0 : (userData["gameCounts"]["yuk_mok"]["win"] / userData["gameCounts"]["yuk_mok"]["games"] * 100).toStringAsFixed(2)}%',
                      ),
                    ],
                    if (!kIsWeb) ...[
                      TabelCellComfortable(query: "승률"),
                      TabelCellComfortable(
                        query:
                            '${userData["gameCounts"]["dol_mok"]["games"] == 0 ? 0 : userData["gameCounts"]["dol_mok"]["win"] / userData["gameCounts"]["dol_mok"]["games"] * 100}%',
                      ),
                      TabelCellComfortable(
                        query:
                            '${userData["gameCounts"]["sa_mok"]["games"] == 0 ? 0 : userData["gameCounts"]["sa_mok"]["win"] / userData["gameCounts"]["sa_mok"]["games"] * 100}%',
                      ),
                      TabelCellComfortable(
                        query:
                            '${userData["gameCounts"]["o_mok"]["games"] == 0 ? 0 : userData["gameCounts"]["o_mok"]["games"] / userData["gameCounts"]["o_mok"]["games"] * 100}%',
                      ),
                      TabelCellComfortable(
                        query:
                            '${userData["gameCounts"]["yuk_mok"]["games"] == 0 ? 0 : userData["gameCounts"]["yuk_mok"]["games"] / userData["gameCounts"]["yuk_mok"]["games"] * 100}%',
                      ),
                    ],
                  ],
                ),
                TableRow(
                  children: [
                    TabelCellComfortable(query: "연승"),
                    TabelCellComfortable(
                      query: '${userData["winningStreak"]["dol_mok"]}',
                    ),
                    TabelCellComfortable(
                      query: '${userData["winningStreak"]["sa_mok"]}',
                    ),
                    TabelCellComfortable(
                      query: '${userData["winningStreak"]["o_mok"]}',
                    ),
                    TabelCellComfortable(
                      query: '${userData["winningStreak"]["yuk_mok"]}',
                    ),
                  ],
                ),
                if (!kIsWeb) ...[
                  TableRow(
                    children: [
                      TabelCellComfortable(query: "승"),
                      TabelCellComfortable(
                        query: '${userData["gameCounts"]["dol_mok"]["win"]}',
                      ),
                      TabelCellComfortable(
                        query: '${userData["gameCounts"]["sa_mok"]["win"]}',
                      ),
                      TabelCellComfortable(
                        query: '${userData["gameCounts"]["o_mok"]["win"]}',
                      ),
                      TabelCellComfortable(
                        query: '${userData["gameCounts"]["yuk_mok"]["win"]}',
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TabelCellComfortable(query: "패"),
                      TabelCellComfortable(
                        query: '${userData["gameCounts"]["dol_mok"]["lose"]}',
                      ),
                      TabelCellComfortable(
                        query: '${userData["gameCounts"]["sa_mok"]["lose"]}',
                      ),
                      TabelCellComfortable(
                        query: '${userData["gameCounts"]["o_mok"]["lose"]}',
                      ),
                      TabelCellComfortable(
                        query: '${userData["gameCounts"]["yuk_mok"]["lose"]}',
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
