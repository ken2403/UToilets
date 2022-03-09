import 'package:flutter/material.dart';

import './pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search available toilet',
      home: const HomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightBlue,
        ).copyWith(
          secondary: Colors.lightGreen,
        ),
        canvasColor: const Color.fromRGBO(255, 254, 249, 1),
        // フォント追加してみた。別にいらないかも
        fontFamily: 'ARIAL',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            bodyText1: const TextStyle(
              fontSize: 18,
            )),
      ),
    );
  }
}
