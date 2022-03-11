import 'package:flutter/material.dart';

import '../pages/homepage.dart';

class PageNavigator extends StatelessWidget {
  /*
    ページ遷移をしてもbottomNavigationBarが残るようにするWidget．
    'lib/paegs/bottom_pages.dart'で指定されたrouteでページが遷移する．
  */
  // constructor
  const PageNavigator({
    Key? key,
    required this.pageItem,
    required this.routeName,
    required this.navigationKey,
    required this.routeBuilder,
  }) : super(key: key);
  final PageItem pageItem;
  final String routeName;
  final GlobalKey<NavigatorState> navigationKey;
  final Map<String, Widget Function(BuildContext)> Function(BuildContext)
      routeBuilder;

  @override
  Widget build(BuildContext context) {
    final _routeBuilder = routeBuilder(context);
    return Navigator(
      key: navigationKey,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        return MaterialPageRoute<Widget>(
          builder: (context) {
            return _routeBuilder[routeName]!(context);
          },
        );
      },
    );
  }
}
