import 'package:flutter/material.dart';


Color getPrimeColor(int code) {
  if(code >= 1 && code < 9) {
    // 문화예술 관람
    return Color(0xFF5947B7);
  }
  else if(code >= 8 && code < 16) {
    // 문화예술 참여
    return Color(0xFFFF7158);
  }
  else if(code >= 16 && code < 20) {
    // 스포츠 관람
    return Color(0xFF5193F6);
  }
  else if(code >= 20 && code < 38) {
    // 스포츠 참여
    return Color(0xFF2A41A6);
  }
  else if(code >= 38 && code < 49) {
    // 관광
    return Color(0xFF009A5A);
  }
  else if(code >= 49 && code < 71) {
    // 취미오락
    return Color(0xFF2C2372);
  }
  else if(code >= 71 && code < 80) {
    // 휴식
    return Color(0xFF6B9847);
  }
  else if(code >= 80 && code < 92) {
    // 사교활동
    return Color(0xFFCD5300);
  }
  return Color(0xFF333333);
}
