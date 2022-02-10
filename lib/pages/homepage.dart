import 'package:flutter/material.dart';

/*
  アプリ起動時の最初のページ

  bottomNavigationBarで画面切り替え

  画面作ったら _bodyWidgets に加える
*/

class HomePage extends StatefulWidget {
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
  // TODO:map画面
  final List<Widget> _bodyWidgets = [
    // searchの画面に対応
    const Center(
      child: Text(
        'search screen',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // mapの画面に対応
    const Center(
      child: Text(
        'map screen',
        style: TextStyle(fontSize: 40),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          // TODO:onPressed
          onPressed: () {},
        ),
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
