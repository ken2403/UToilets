import 'package:flutter/material.dart';

import '../pages/bottom_pages.dart';
import '../pages/search_page.dart';
import '../pages/map_page.dart';
import '../pages/mypage/mypage_page.dart';

// setting up contents of bottom navigation bar with using PageItem
const pageTitle = <PageItem, String>{
  PageItem.search: '検索',
  PageItem.map: '地図',
  PageItem.mypage: 'マイページ',
};
const pageTooltip = <PageItem, String>{
  PageItem.search: SearchPage.title,
  PageItem.map: MapPage.title,
  PageItem.mypage: MyPage.title,
};
const pageIcon = <PageItem, IconData>{
  PageItem.search: Icons.search,
  PageItem.map: Icons.location_on,
  PageItem.mypage: Icons.person,
};

class BottomNavigation extends StatefulWidget {
  /*
    'lib/widgets/page_navigator.dart'と一緒に，ページ遷移をしてもbottomNavigationBarが残るようにするWidget．
    BottomNavgationBarを生成するWidget．
  */
  // constructor
  const BottomNavigation(
      {Key? key, required this.currentPage, required this.onSelect})
      : super(key: key);
  final PageItem currentPage;
  final ValueChanged<PageItem> onSelect;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  // set some variables
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // function to make BottomNavigationBarItems
  BottomNavigationBarItem bottomItem(BuildContext context,
      {required PageItem pageItem}) {
    return BottomNavigationBarItem(
      icon: Icon(
        pageIcon[pageItem],
      ),
      label: pageTitle[pageItem],
      tooltip: pageTooltip[pageItem],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      selectedLabelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      items: <BottomNavigationBarItem>[
        bottomItem(
          context,
          pageItem: PageItem.search,
        ),
        bottomItem(
          context,
          pageItem: PageItem.map,
        ),
        bottomItem(
          context,
          pageItem: PageItem.mypage,
        ),
      ],
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        _onItemTapped(index);
        widget.onSelect(PageItem.values[index]);
      },
    );
  }
}
