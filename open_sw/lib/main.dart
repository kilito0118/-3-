import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_sw/login/login_screen.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:open_sw/mainPage/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final naverMapApi = dotenv.env['NAVER_API_KEY'];

  await FlutterNaverMap().init(
    clientId: naverMapApi,
    onAuthFailed:
        (ex) => switch (ex) {
          NQuotaExceededException(:final message) => debugPrint(
            "사용량 초과 (message: $message)",
          ),
          NUnauthorizedClientException() ||
          NClientUnspecifiedException() ||
          NAnotherAuthFailedException() => debugPrint("인증 실패: $ex"),
        },
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    //var baseStyle = TextStyle(fontFamily: '힘찬체', color: Colors.black);
    return MaterialApp(
      locale: Locale('ko', 'KR'), // 한국어로 고정
      supportedLocales: [
        Locale('ko', 'KR'), // 지원하는 언어에 한국어만 추가
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
      home: user == null ? LoginScreen() : HomeScreen(),
      //home: LoginScreen(),
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
