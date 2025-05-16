import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.userName});
  final String userName;
  @override
  State<StatefulWidget> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 82, width: 26),
              Text(
                "안녕하세요,\n${widget.userName}님.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              Icon(Icons.account_circle_rounded, size: 68),
              /*
              ClipOval(
                child: Image(
                  image: AssetImage(["assets/images/", log].join()),
                  height: 100.0,
                  width: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
              */
            ],
          ),
        ],
      ),
    );
  }
}
