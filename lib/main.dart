import 'package:flutter/material.dart';
import './pages/map_page.dart';
import './pages/search_page.dart';
import './pages/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'washlet': false,
  };

  void _setFilters(Map<String, bool> filterData) {

  }
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
        MapPage.routeName: (ctx) => MapPage(),
        SearchPage.routeName: (ctx) => SearchPage(),
      },
    );
  }
}
