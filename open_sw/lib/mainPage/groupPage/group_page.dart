import 'package:flutter/material.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/group_plus_tile_widget.dart';
import 'package:open_sw/mainPage/groupPage/groupWidget/group_tile_widget.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.userName});
  final String userName;
  @override
  State<StatefulWidget> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final List<Group> exampleGroups = [
    Group(
      id: "Qweeafs",
      name: 'Flutter Developers',
      leader: 'Alice',
      members: ['Alice', 'Bob', 'Charlie', 'Diana'],
      memberCount: 4,
    ),
    Group(
      id: "Qwe",
      name: 'AI Study Club',
      leader: 'Eve',
      members: ['Eve', 'Frank', 'Grace'],
      memberCount: 3,
    ),
    Group(
      id: "Qwe5",
      name: 'Running Team',
      leader: 'Henry',
      members: ['Henry', 'Ivy', 'Jack', 'Kelly', 'Leo'],
      memberCount: 5,
    ),
    Group(
      id: "Qwe3",
      name: 'Book Lovers',
      leader: 'Mona',
      members: ['Mona', 'Nate'],
      memberCount: 2,
    ),
    Group(
      id: "Qwe2",
      name: 'Music Band',
      leader: 'Oscar',
      members: ['Oscar', 'Paul', 'Quinn', 'Rita'],
      memberCount: 4,
    ),
  ];

  //List<Group> groups;
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 82, width: 26),
              Text(
                "안녕하세요,\n${widget.userName}님.",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 83),
              Icon(Icons.account_circle_rounded, size: 68),
            ],
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.only(left: 26, right: 26),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        "나의 그룹",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "편집",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),

                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: exampleGroups.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < exampleGroups.length) {
                            return GroupTileWidget(group: exampleGroups[index]);
                          } else {
                            return GroupPlusTileWidget();
                          }
                        },
                      ),
                      SizedBox(height: 140),
                      Text(""),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 140),
          Text(""),
        ],
      ),
    );
  }
}
