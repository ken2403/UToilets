import 'package:flutter/material.dart';
import 'package:flutter_app/pages/search_page.dart';

import './map_page_.dart';

class HomeDrawer extends StatelessWidget {
  /*
    // TODO:ページの説明
  */
  // constructor
  const HomeDrawer({Key? key}) : super(key: key);

  Widget buildListTile(BuildContext context, String title, IconData icon,
      VoidCallback tapHandler) {
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return MapPage.any(
                sex: RadioValueSex.all,
                barTitle: '検索結果',
              );
            }));
          }),
        ],
      ),
    );
  }
}
