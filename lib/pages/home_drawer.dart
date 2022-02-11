import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: const Text('DrawerHeader'),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const ListTile(
          title: Text('Drawer1'),
          trailing: Icon(Icons.arrow_forward),
        ),
        const ListTile(
          title: Text('Drawer2'),
          trailing: Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
