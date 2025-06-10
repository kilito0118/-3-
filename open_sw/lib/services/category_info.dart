import 'package:flutter/material.dart';
import 'package:open_sw/useful_widget/commonWidgets/common_widgets.dart';


Icon getPrimeIcon(int code, double size) {
  if(code >= 1 && code < 9) {
    // 문화예술 관람
    return Icon(Icons.event_seat, color: Color(0xFFB66262), size: size,);
  }
  else if(code >= 8 && code < 16) {
    // 문화예술 참여
    return Icon(Icons.music_note, color: themeRed, size: size,);
  }
  else if(code >= 16 && code < 20) {
    // 스포츠 관람
    return Icon(Icons.emoji_events, color: themeYellow, size: size,);
  }
  else if(code >= 20 && code < 38) {
    // 스포츠 참여
    return Icon(Icons.sports_basketball, color: themeOrange, size: size,);
  }
  else if(code >= 38 && code < 49) {
    // 관광
    return Icon(Icons.terrain, color: themeGreen, size: size,);
  }
  else if(code >= 49 && code < 71) {
    // 취미오락
    return Icon(Icons.tv, color: Colors.blueGrey, size: size,);
  }
  else if(code >= 71 && code < 80) {
    // 휴식
    return Icon(Icons.chair, color: Color(0xff47a2ca), size: size,);
  }
  else if(code >= 80 && code < 92) {
    // 사교활동
    return Icon(Icons.people, color: Colors.blueAccent, size: size,);
  }
  return Icon(Icons.block, color: Colors.grey, size: size,);
}
