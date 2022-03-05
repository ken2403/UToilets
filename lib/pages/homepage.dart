import 'package:flutter/material.dart';
import 'package:flutter_app/pages/filters_page.dart';
import './search_page.dart';

import './map_page.dart';
import './home_drawer.dart';

class HomePage extends StatefulWidget {
  /*
    アプリ起動時の最初のページ．
    bottomNavigationBarで画面切り替え．
  */
  // routing
  static const routeName = '/';
  // constructor
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bottomNavigationBarを押した時のページ遷移の関数
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // searchで条件フィルターしてmap上に条件のデータを表示する際には./widgets/map_widget.dart を使うとフィルターできるようにしてある(詳細はそっち確認)
  // dataの形式については assets/data/toilet.jsonを確認して(とりあえず作っただけだから今後変更可能)
  String mapTitle = '地図からトイレを探す';
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
    final List<Widget> _bodyWidgets = [
      // index0: searchの画面に対応
      const SearchPage(),
      // index1: mapの画面に対応
      const MapPage(
        filters: {
          'multipurpose': false,
          'washlet': false,
          'madeyear': 1900,
          'recyclePaper': false,
          'singlePaper': false,
          'seatWarmer': false,
          'isfiltered': false,
        },
        title: '地図からトイレを探す',
      ),
      FilterPage(
        currentFilters: const {
          'multipurpose': false,
          'washlet': false,
          'madeyear': 1900,
          'recyclePaper': false,
          'singlePaper': false,
          'seatWarmer': false,
          'isfiltered': false,
        },
        saveFilters: _setFilters,
      )
    ];
    return Scaffold(
      drawer: const HomeDrawer(),
      body: _bodyWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
            tooltip: SearchPage.title,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'map',
            tooltip: '地図からトイレを探す',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          )
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedFontSize: 15,
      ),
    );
  }
}
