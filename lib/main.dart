import 'package:flutter/material.dart';
import './pages/fliters_page.dart';
import './pages/map_page.dart';
import './pages/search_page.dart';
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
  Map<String, Object> _filters = {
    'multipurpose': false,
    'washlet': false,
    'madeyear': 1900,
    'recyclePaper': false,
    'singlePaper': false,
    'seatWarmer': false,
    'isfiltered': false,
  };

  void _setFilters (Map<String, Object> filterData) {
    setState(() {
      _filters = filterData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search available toilet',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.lightGreen,
        canvasColor: Color.fromRGBO(255, 254, 249, 1),
        // フォント追加してみた。別にいらないかも
        fontFamily: 'ARIAL',
        textTheme: ThemeData.light().textTheme.copyWith(
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
        '/': (ctx) => HomePage(title: 'トイレを探す'),
        MapPage.routeName: (ctx) => MapPage(filters: _filters),
        SearchPage.routeName: (ctx) => SearchPage(),
        FilterPage.routeName: (ctx) => FilterPage(currentFilters: _filters, saveFilters: _setFilters),
      },
    );
  }
}
