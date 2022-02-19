import 'package:flutter/material.dart';
import './pages/map_page.dart';
import './pages/search_page.dart';
import './pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search available toilet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightGreen,
        ).copyWith(
          secondary: Colors.lightBlue,
        ),
        // フォント追加してみた。別にいらないかも
        fontFamily: 'ARIAL',
        textTheme: const TextTheme(
            headline6: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            bodyText1: TextStyle(
              fontSize: 18,
            )),
      ),
      initialRoute: '/',
      routes: {
        // searchpage、mappageへのrouteを追加。
        '/': (ctx) => const HomePage(title: 'トイレを探す'),
        MapPage.routeName: (ctx) => MapPage(),
        SearchPage.routeName: (ctx) => SearchPage(),
      },
    );
  }
}
