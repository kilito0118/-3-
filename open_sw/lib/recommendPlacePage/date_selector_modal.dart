import 'package:flutter/material.dart';

import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';

class DateSelectorModal extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, String> place;

  const DateSelectorModal({
    super.key,
    required this.selectedDate,
    required this.place,
  });

  @override
  State<DateSelectorModal> createState() => _DateSelectorModalState();
}

class _DateSelectorModalState extends State<DateSelectorModal> {
  late DateTime _selectedDate;

  // 초기 날짜를 현재 날짜로 지정
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
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
              headerBackgroundColor: Colors.black.withAlpha(20),
              dividerColor: Colors.transparent
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
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
      alpha: 200,
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
                    Text('날짜', style: contentsNormal),
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
                    Text('시간', style: contentsNormal),
                    spacingBox(),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        style: btn_normal(),
                        child: const Text('00 시'),
                      ),
                    ),
                    spacingBox(),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        style: btn_normal(),
                        child: const Text('00 분'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          spacingBox(),
          SubmitButtonBig(text: '그룹 일정에 추가', onTap: () {}),
          spacingBox_withComment('그룹 일정에 추가하면 그룹원들이 만날 장소와 시간을 볼 수 있어요.'),
          bottomNavigationBarSpacer(context),
        ],
      ),
    );
  }
}
