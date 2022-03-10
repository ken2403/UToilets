import 'package:flutter/material.dart';

import './search_page.dart';
import './map_page.dart';
import './mypage/mypage_page.dart';

/* 
  'lib/pages/homepage.dart'のHomePage中のbottomNavigationBarのページの設定．
  routeとコンストラクトしたWidgetを設定する．
*/

// enum of bottom navigation pages
enum PageItem {
  search,
  map,
  mypage,
}

// setting page routes and widgets
Map<String, Widget Function(BuildContext)> routeBuilder(BuildContext context) =>
    {
      SearchPage.route: (context) => const SearchPage(),
      MapPage.route: (context) =>
          MapPage.any(sex: ChosenSex.male, barTitle: MapPage.title),
      MyPage.route: (context) => const MyPage(),
    };
