import 'package:flutter/material.dart';
import 'package:open_sw/login/login_screen.dart';

//import 'package:open_sw/naver_directions_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //var baseStyle = TextStyle(fontFamily: '힘찬체', color: Colors.black);
    return MaterialApp(
      /*
      theme: ThemeData(
        fontFamily: '힘찬체',
        textTheme: TextTheme(
          displayLarge: baseStyle.copyWith(fontSize: 18),
          displayMedium: baseStyle.copyWith(fontSize: 13),
          bodyLarge: baseStyle.copyWith(fontSize: 32),
          bodyMedium: baseStyle.copyWith(fontSize: 28),
          bodySmall: baseStyle.copyWith(fontSize: 22),
          titleLarge: baseStyle.copyWith(fontSize: 76),
          titleMedium: baseStyle.copyWith(fontSize: 36),
        ),
      ),
      */
      home: LoginScreen(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:open_sw/mainPage/friendPage/friend_page.dart'; // 경로는 실제 위치에 맞게 조정하세요

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Firebase 초기화
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Friend App',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: const FriendPage(),
//     );
//   }
// }
