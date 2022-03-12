import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './intro_page.dart';
import './search_page.dart';
import './map_page.dart';
import './mypage/mypage_page.dart';
import '../widgets/bottom_navigator.dart';
import '../widgets/page_navigator.dart';

// enum for seleceted sex
enum ChosenSex {
  male,
  female,
}
// enum of bottom navigation pages
enum PageItem {
  search,
  map,
  mypage,
}

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
  // set some variables for intro page
  bool _endIntro = false;
  ChosenSex _chosenSex = ChosenSex.male;
  // set some variables for homepage
  final Map<PageItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    PageItem.search: GlobalKey<NavigatorState>(),
    PageItem.map: GlobalKey<NavigatorState>(),
    PageItem.mypage: GlobalKey<NavigatorState>(),
  };
  PageItem _currentPage = PageItem.values[0];

  // check whether finish introduction
  Future<void> _checkIntro() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('endIntro') == null) {
      await prefs.setBool('endIntro', _endIntro);
    } else if (!prefs.getBool('endIntro')!) {
      setState(() {
        _endIntro = true;
      });
      await prefs.setBool('endIntro', true);
    } else {
      setState(() {
        _endIntro = prefs.getBool('endIntro')!;
      });
    }
  }

  // set sex
  Future<void> _setSex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('sex') != null) {
      setState(() {
        _chosenSex =
            prefs.getInt('sex') == 0 ? ChosenSex.male : ChosenSex.female;
      });
    }
  }

  // function to change _chosenSex to selected sex
  void _onRadioSelected(value) {
    setState(() {
      _chosenSex = value;
    });
  }

  // function for introduction end button
  Future<void> _onIntroEnd() async {
    setState(() {
      _endIntro = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sex', _chosenSex == ChosenSex.male ? 0 : 1);
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
  void initState() {
    super.initState();
    _checkIntro();
  }

  @override
  Widget build(BuildContext context) {
    _setSex();
    // if finish intro, build main page homepage
    if (_endIntro) {
      Map<String, Widget Function(BuildContext)> routeBuilder(
              BuildContext context) =>
          {
            SearchPage.route: (context) => const SearchPage(),
            MapPage.route: (context) =>
                MapPage.any(sex: _chosenSex, barTitle: MapPage.title),
            MyPage.route: (context) => const MyPage(),
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
    // if not finish intro, build intro page
    else {
      return IntroPage(
        chosenSex: _chosenSex,
        selectedSexRadio: _onRadioSelected,
        onIntroEnd: _onIntroEnd,
      );
    }
  }
}
