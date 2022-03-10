import 'package:flutter/material.dart';

import './map_page.dart';
import './mypage/mypage_page.dart';
import './search_page.dart';
import './bottom_pages.dart';
import '../widgets/bottom_navigator.dart';
import '../widgets/page_navigator.dart';

class HomePage extends StatefulWidget {
  /*
    アプリ起動時の最初のページ．
    bottomNavigationBarで画面切り替え．
  */
  // constructor
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // set some variables
  PageItem _currentPage = PageItem.values[0];
  final Map<PageItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    PageItem.search: GlobalKey<NavigatorState>(),
    PageItem.map: GlobalKey<NavigatorState>(),
    PageItem.mypage: GlobalKey<NavigatorState>(),
  };

  // function to change the display widget
  Widget _buildPageItem(PageItem pageItem, String root) {
    return Offstage(
      offstage: _currentPage != pageItem,
      child: PageNavigator(
        navigationKey: _navigatorKeys[pageItem]!,
        pageItem: pageItem,
        routeName: root,
        routeBuilder: routeBuilder,
      ),
    );
  }

  // function to chante page when tapped other bottom navigation bar item
  void _onSelect(PageItem pageItem) {
    if (_currentPage == pageItem) {
      _navigatorKeys[pageItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildPageItem(
            PageItem.search,
            SearchPage.route,
          ),
          _buildPageItem(
            PageItem.map,
            MapPage.route,
          ),
          _buildPageItem(
            PageItem.mypage,
            MyPage.route,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentPage: _currentPage,
        onSelect: _onSelect,
      ),
    );
  }
}
