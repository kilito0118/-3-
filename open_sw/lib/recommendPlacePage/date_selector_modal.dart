import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_sw/mypage/recent_activity.dart';
import 'package:open_sw/mypage/regist_activity.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

class DateSelectorModal extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, String> place;
  final int type;
  final String groupId;

  const DateSelectorModal({
    required this.groupId,
    super.key,
    required this.selectedDate,
    required this.place,
    required this.type,
  });

  @override
  State<DateSelectorModal> createState() => _DateSelectorModalState();
}

class _DateSelectorModalState extends State<DateSelectorModal> {
  late DateTime _selectedDate;
  late int _selectedHour;
  late int _selectedMinute;

  // 일정 등록 함수(구현 필요)
  Future<void> submit() async {
    if (_selectedDate.isBefore(DateTime.now())) {
      // 날짜가 너무 이르면 경고 출력
      showCustomDialog(
        context: context,
        title: '날짜 오류!',
        message: '선택된 날짜가 너무 이릅니다!',
        child: SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: btn_normal(),
            child: Text('확인'),
          ),
        ),
      );
      return;
    }
    // 그룹 데이터 불러오기
    final groupDoc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((doc) => doc.exists ? doc.data() : null);
    Map<String, dynamic> groupData = groupDoc as Map<String, dynamic>;

    registActivity(
      Activity(
        type: widget.type,
        place: widget.place,
        date: _selectedDate,
        groupId: widget.groupId,
        score: List.generate(
          groupData['members'].length + 1,
          (_) => 0,
        ), // 초기 점수는 모두 0으로 설정
        userId: [...groupData['members'], groupData['leader']], // 멤버 리스트에 리더 추가
      ),
    );
    // 프린트 함수 지우고 일정추가 기능 구현 필요
    print(widget.place['name']);
    print(_selectedDate);

    // 팝업 보여주고 확인 누르면 모달 닫기
    showCustomDialog(
      context: context,
      title: '일정에 추가됨',
      message: '일정에 정상적으로 추가되었습니다',
      icon: Icons.check,
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          style: btn_normal(),
          child: Text('확인'),
        ),
      ),
    );
  }

  // 초기 날짜를 현재 날짜로 지정
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _selectedHour = _selectedDate.hour;
    _selectedMinute = _selectedDate.minute;
  }

  // 날짜 선택창
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              headerBackgroundColor: Colors.black.withAlpha(10),
              dividerColor: Colors.black.withAlpha(20),
            ),
            colorScheme: const ColorScheme.light(
              primary: themeOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    // 상태 업데이트
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedHour,
          _selectedMinute,
        );
      });
    }
  }

  // 날짜 텍스트로 변환
  String get dateText {
    final year = _selectedDate.year.toString();
    final month = _selectedDate.month.toString().padLeft(2, '0');
    final day = _selectedDate.day.toString().padLeft(2, '0');
    return '$year년 $month월 $day일';
  }

  @override
  Widget build(BuildContext context) {
    return BlurredBox(
      width: double.infinity,
      topRad: 20,
      horizontalPadding: 14.0,
      verticalPadding: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gestureBar(),
          mainTitle('언제 모이나요?'),
          subTitle(widget.place['name'] ?? ''),
          spacingBox(),
          ContentsBox(
            child: Column(
              children: [
                Row(
                  children: [
                    IconBox(icon: Icons.today, color: Colors.deepPurpleAccent),
                    spacingBox_mini(),
                    Text('날짜', style: contentsNormal()),
                    spacingBox(),
                    Expanded(
                      child: TextButton(
                        onPressed: _pickDate,
                        style: btn_normal(),
                        child: Text(dateText),
                      ),
                    ),
                  ],
                ),
                spacingBox_devider(),
                Row(
                  children: [
                    IconBox(icon: Icons.timer, color: themeOrange),
                    spacingBox_mini(),
                    Text('시간', style: contentsNormal()),
                    spacingBox(),
                    // 시간 선택 버튼
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedHour,
                        isDense: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withAlpha(20),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: Colors.white,
                        style: contentsNormal(),
                        items: List.generate(24, (index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text('${index.toString().padLeft(2, '0')}시'),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedHour = value;
                              _selectedDate = DateTime(
                                _selectedDate.year,
                                _selectedDate.month,
                                _selectedDate.day,
                                _selectedHour,
                                _selectedMinute,
                              );
                            });
                          }
                        },
                      ),
                    ),
                    spacingBox(),
                    // 분 선택 버튼
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedMinute,
                        isDense: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black.withAlpha(20),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownColor: Colors.white,
                        style: contentsNormal(),
                        items: List.generate(60, (index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text('${index.toString().padLeft(2, '0')}분'),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedMinute = value;
                              _selectedDate = DateTime(
                                _selectedDate.year,
                                _selectedDate.month,
                                _selectedDate.day,
                                _selectedHour,
                                _selectedMinute,
                              );
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          spacingBox(),
          SubmitButtonBig(text: '그룹 일정에 추가', onTap: () => submit()),
          spacingBox_withComment('그룹 일정에 추가하면 그룹원들이 만날 장소와 시간을 볼 수 있어요.'),
          bottomNavigationBarSpacer(context),
        ],
      ),
    );
  }
}
