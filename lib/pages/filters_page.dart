import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_drawer.dart';
import '../Icon/multipurpose_toilet.dart';

class FilterPage extends StatefulWidget {
  /*
    TODO:ページの説明
  */
  // routing
  static const routeName = '/filters';
  // constructor
  const FilterPage(
      {Key? key, required this.currentFilters, required this.saveFilters})
      : super(key: key);
  final Map<String, Object> currentFilters;
  final void Function(Map<String, Object>)? saveFilters;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  bool isfiltered = false;
  bool multipurpose = false;
  bool washlet = false;
  int madeyear = 1900;
  bool recyclePaper = false;
  bool singlePaper = false;
  bool seatWarmer = false;

  //
  @override
  void initState() {
    multipurpose = widget.currentFilters['multipurpose'] as bool;
    washlet = widget.currentFilters['washlet'] as bool;
    madeyear = widget.currentFilters['madeyear'] as int;
    recyclePaper = widget.currentFilters['recyclePaper'] as bool;
    singlePaper = widget.currentFilters['singlePaper'] as bool;
    seatWarmer = widget.currentFilters['seatWarmer'] as bool;
    super.initState();
  }

  Widget _buildDropdownButton(int madeyear, void Function(int?) update) {
    return ListTile(
      title: Text(
        '製造年',
      ),
      subtitle: Text('設定年以降に作られた場所のみ表示'),
      trailing: DropdownButton(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('検索条件の設定'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              final selectedFilters = {
                'multipurpose': multipurpose,
                'washlet': washlet,
                'madeyear': madeyear,
                'recyclePaper': recyclePaper,
                'singlePaper': singlePaper,
                'seatWarmer': seatWarmer,
                'isfiltered': isfiltered,
              };
              widget.saveFilters!(selectedFilters);
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: Text(
              '保存',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(children: <Widget>[
        Container(
          child: Text('選択してください'),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              SwitchListTile(
                  title: Text('ウォシュレット'),
                  subtitle: Text('ウォシュレットがある場所のみ表示'),
                  value: washlet,
                  onChanged: (newValue) {
                    setState(() {
                      washlet = newValue;
                      isfiltered = true;
                    });
                  }),
              SwitchListTile(
                  secondary: Icon(multipurpose_toilet.wheelchair),
                  title: Text('多目的トイレ'),
                  subtitle: Text('多目的トイレがある場所のみ表示'),
                  value: multipurpose,
                  onChanged: (newValue) {
                    setState(() {
                      multipurpose = newValue;
                      isfiltered = true;
                    });
                  }),
              SwitchListTile(
                  title: Text('再生紙'),
                  subtitle: Text('再生紙がある場所のみ表示'),
                  value: recyclePaper,
                  onChanged: (newValue) {
                    setState(() {
                      recyclePaper = newValue;
                      isfiltered = true;
                    });
                  }),
              SwitchListTile(
                  title: Text('singlePaper'),
                  subtitle: Text('singlePaperがある場所のみ表示'),
                  value: singlePaper,
                  onChanged: (newValue) {
                    setState(() {
                      singlePaper = newValue;
                      isfiltered = true;
                    });
                  }),
              SwitchListTile(
                  title: Text('温かい便座'),
                  subtitle: Text('温かい便座がある場所のみ表示'),
                  value: seatWarmer,
                  onChanged: (newValue) {
                    setState(() {
                      seatWarmer = newValue;
                      isfiltered = true;
                    });
                  }),
              _buildDropdownButton(madeyear, (int? newValue) {
                setState(() {
                  madeyear = newValue!;
                  isfiltered = true;
                });
              }),
            ],
          ),
        ),
      ]),
    );
  }
}
