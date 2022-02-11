import 'package:flutter/material.dart';

import './map_page.dart';
import './home_drawer.dart';

class HomePage extends StatefulWidget {
  /*
    アプリ起動時の最初のページ
    bottomNavigationBarで画面切り替え
    検索用の画面を作ったら List<Widget> _bodyWidgets に加える
  */
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // TODO:search画面(作ったらこのコメント消して)
  // 画面を構成するwidgetは別ファイルで作成してここで使うイメージ
  final List<Widget> _bodyWidgets = [
    // searchの画面に対応
    const Center(
      child: Text(
        'search screen',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // mapの画面に対応
    const MapPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: HomeDrawer(),
      ),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: _bodyWidgets[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'map',
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedFontSize: 15,
      ),
    );
  }
}
