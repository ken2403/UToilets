import 'package:flutter/material.dart';
import 'filters_page.dart';
import './map_page.dart';

// TODO:drawer作る
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);
  Widget buildListTile(
      BuildContext context, String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(title, style: TextStyle(fontFamily: 'OpenSans')),
      trailing: Icon(Icons.arrow_forward),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: const Text('DrawerHeader'),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          buildListTile(context, 'ホーム', Icons.home, () {
            Navigator.of(context).pushNamed('/');
          }),
          buildListTile(context, 'トイレを探す', Icons.location_on, () {
            Navigator.of(context).pushNamed(MapPage.routeName);
          }),
          buildListTile(context, '厳選する', Icons.settings, () {
            Navigator.of(context).pushNamed(FilterPage.routeName);
          }),
        ],
      ),
    );
  }
}
