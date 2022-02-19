import 'package:flutter/material.dart';
import './map_page.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/searchpage';

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isfiltered = false;
  bool washlet = false;
  int madeyear = 1900;

  void FilteredMap(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      MapPage.routeName,
      arguments: {
        'washlet': washlet,
        'madeyear': madeyear,
        'isfiltered': isfiltered,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'フィルタリング',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SwitchListTile(
              title: Text('ウォシュレット'),
              value: washlet,
              onChanged: (newValue) {
                setState(() {
                  washlet = newValue;
                  isfiltered = true;
                });
              },
            ),
            DropdownButton(
              value: madeyear,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: Theme.of(context).textTheme.headline6,
              onChanged: (int? newValue) {
                setState(() {
                  madeyear = newValue!;
                });
              },
              items: <int>[
                1900,
                1910,
                1920,
                1930,
                1940,
                1950,
                1960,
                1970,
                1980,
                1990,
                2000,
                2010,
                2020
              ].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => FilteredMap(context),
      ),
    );
  }
}
