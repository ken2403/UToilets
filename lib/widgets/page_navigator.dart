import 'package:flutter/material.dart';

import '../pages/bottom_pages.dart';

class PageNavigator extends StatelessWidget {
  /*
    TODO:説明
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
