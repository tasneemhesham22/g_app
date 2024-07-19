// import 'package:flutter/material.dart';
// import 'package:g_app/screens/home_screen.dart';
// import 'package:g_app/screens/login_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "sport App",
//       theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF001F3F)),
//           useMaterial3: true),
//       home: HomeScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
