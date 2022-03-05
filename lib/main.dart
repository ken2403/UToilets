import 'package:flutter/material.dart';
import 'pages/filters_page.dart';
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
  // global変数(下の_filters)をこのmain.dartファイルで管理している。
  // filter_pageでウォシュレットとかが選択されて保存が押されたらfilter_pageのwashlet変数だけでなくこのgloabal変数も変更するようにしている。
  // この変更されたglobal変数を下のrouteからmap_pageへ送ることでフィルタリングされたトイレのみmap_page→map_widgetで表示されるようになっている。
  Map<String, Object> _filters = {
    'multipurpose': false,
    'washlet': false,
    'madeyear': 1900,
    'recyclePaper': false,
    'singlePaper': false,
    'seatWarmer': false,
    'isfiltered': false,
  };

  void _setFilters(Map<String, Object> filterData) {
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
      initialRoute: '/',
      routes: {
        HomePage.routeName: (ctx) => const HomePage(),
        SearchPage.routeName: (ctx) => const SearchPage(),
        MapPage.routeNameFromSearch: (ctx) =>
            MapPage(filters: _filters, title: '検索結果'),
        MapPage.routeName: (ctx) => MapPage(filters: _filters, title: '地図から探す'),
        // global変数(main.dart内の_filtersとそれを更新する関数をfilter_pageに引数として渡している。)
        FilterPage.routeName: (ctx) =>
            FilterPage(currentFilters: _filters, saveFilters: _setFilters),
      },
    );
  }
}
