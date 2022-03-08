import 'package:flutter/material.dart';

import './search_page.dart';
import './map_page.dart';
import './mypage_page.dart';

// enum of bottom navigation pages
enum PageItem {
  search,
  map,
  mypage,
}

// function to return the page of setting route
Map<String, Widget Function(BuildContext)> routeBuilder(BuildContext context) =>
    {
      SearchPage.route: (context) => const SearchPage(),
      MapPage.route: (context) =>
          MapPage.any(sex: RadioValueSex.all, barTitle: MapPage.title),
      MyPage.route: (context) => const MyPage(),
    };
