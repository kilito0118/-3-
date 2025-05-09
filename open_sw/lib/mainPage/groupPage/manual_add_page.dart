import 'package:flutter/material.dart';

class ManualAddPage extends StatefulWidget {
  const ManualAddPage({super.key});

  @override
  State<ManualAddPage> createState() => _ManualAddPageState();
}

class _ManualAddPageState extends State<ManualAddPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text("직접 추가하기", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            InputField(label: "이름", controller: nameController),
            SizedBox(height: 16),
            InputField(label: "나이", controller: ageController),
            SizedBox(height: 24),
            Text("성별", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GenderButton(
                    label: "남성",
                    color: Colors.blue,
                    selected: selectedGender == "남성",
                    onTap: () => setState(() => selectedGender = "남성"),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GenderButton(
                    label: "여성",
                    color: Colors.red,
                    selected: selectedGender == "여성",
                    onTap: () => setState(() => selectedGender = "여성"),
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                print(
                  "이름: ${nameController.text}, 나이: ${ageController.text}, 성별: $selectedGender",
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.orangeAccent, Colors.deepOrange],
                  ),
                ),
                child: Center(
                  child: Text(
                    "그룹에 추가하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 공통 텍스트 입력 필드
class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const InputField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }
}

// 성별 선택 버튼
class GenderButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const GenderButton({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(selected ? 1.0 : 0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
