// 機能していません。

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

  // 製造年月日の所のwidget。見た目は後で変更
  // ウォシュレットのスイッチや製造年月日を設定すると_SearchPageStateクラスの3つのプロパティ（isfiltered, washlet, madeyear）が変更される。
  // 変更された変数をmappageに遷移するときに引き渡す。
  Widget _buildDropdownButton(int madeyear, void Function(int?) update) {
    return Row(
      children: [
        Text(
          '製造年月日',
        ),
        DropdownButton(
          value: madeyear,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          onChanged: update,
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
        Text(
          '年以降',
        ),
      ],
    );
  }

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
            _buildDropdownButton(madeyear, (int? newValue) {
              setState(() {
                madeyear = newValue!;
              });
            }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        // 下の検索アイコンを押すとmappageに推移し、washletと製造年月日の情報もargumentとして渡す。
        onPressed: () => FilteredMap(context),
      ),
    );
  }
}
