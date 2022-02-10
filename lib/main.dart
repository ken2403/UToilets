import 'package:flutter/material.dart';

import './pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search available toilet',
      theme: ThemeData(
        // 色はとりあえず好きだから緑＋青で作ってみた、この先の過程でまた変更しても良い
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightGreen,
        ).copyWith(
          secondary: Colors.lightBlue,
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const HomePage(title: 'トイレを探す'),
      },
    );
  }
}
