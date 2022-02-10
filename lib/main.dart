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
      // theme: ThemeData(primarySwatch: Colors.lightGreen),
      theme: ThemeData(
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
