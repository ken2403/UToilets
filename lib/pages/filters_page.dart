import 'package:flutter/material.dart';
import '../Icon/multipurpose_toilet.dart';

class FilterPage extends StatefulWidget {
  /*
    検索条件を設定するページ
    このあとこれをどう使うかは今のところ未定
  */
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
  // set some variables
  bool _isfiltered = false;
  bool _multipurpose = false;
  bool _washlet = false;
  int _madeYear = 1900;
  bool _recyclePaper = false;
  bool _singlePaper = false;
  bool _seatWarmer = false;

  @override
  void initState() {
    _multipurpose = widget.currentFilters['multipurpose'] as bool;
    _washlet = widget.currentFilters['washlet'] as bool;
    _madeYear = widget.currentFilters['madeYear'] as int;
    _recyclePaper = widget.currentFilters['recyclePaper'] as bool;
    _singlePaper = widget.currentFilters['singlePaper'] as bool;
    _seatWarmer = widget.currentFilters['seatWarmer'] as bool;
    super.initState();
  }

  Widget _buildDropdownButton(int madeYear, void Function(int?) update) {
    return ListTile(
      title: const Text(
        '製造年',
      ),
      subtitle: const Text('設定年以降に作られた場所のみ表示'),
      trailing: DropdownButton(
        value: madeYear,
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
        title: const Text('検索条件の設定'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              final selectedFilters = {
                'multipurpose': _multipurpose,
                'washlet': _washlet,
                'madeYear': _madeYear,
                'recyclePaper': _recyclePaper,
                'singlePaper': _singlePaper,
                'seatWarmer': _seatWarmer,
                'isfiltered': _isfiltered,
              };
              widget.saveFilters!(selectedFilters);
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text(
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
          padding: const EdgeInsets.all(10),
          child: const Text('選択してください'),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              SwitchListTile(
                  title: const Text('ウォシュレット'),
                  subtitle: const Text('ウォシュレットがある場所のみ表示'),
                  value: _washlet,
                  onChanged: (newValue) {
                    setState(() {
                      _washlet = newValue;
                      _isfiltered = true;
                    });
                  }),
              SwitchListTile(
                  secondary: const Icon(MultipurposeToilet.wheelchair),
                  title: const Text('多目的トイレ'),
                  subtitle: const Text('多目的トイレがある場所のみ表示'),
                  value: _multipurpose,
                  onChanged: (newValue) {
                    setState(() {
                      _multipurpose = newValue;
                      _isfiltered = true;
                    });
                  }),
              SwitchListTile(
                  title: const Text('再生紙'),
                  subtitle: const Text('再生紙がある場所のみ表示'),
                  value: _recyclePaper,
                  onChanged: (newValue) {
                    setState(() {
                      _recyclePaper = newValue;
                      _isfiltered = true;
                    });
                  }),
              SwitchListTile(
                  title: const Text('singlePaper'),
                  subtitle: const Text('singlePaperがある場所のみ表示'),
                  value: _singlePaper,
                  onChanged: (newValue) {
                    setState(() {
                      _singlePaper = newValue;
                      _isfiltered = true;
                    });
                  }),
              SwitchListTile(
                  title: const Text('温かい便座'),
                  subtitle: const Text('温かい便座がある場所のみ表示'),
                  value: _seatWarmer,
                  onChanged: (newValue) {
                    setState(() {
                      _seatWarmer = newValue;
                      _isfiltered = true;
                    });
                  }),
              _buildDropdownButton(_madeYear, (int? newValue) {
                setState(() {
                  _madeYear = newValue!;
                  _isfiltered = true;
                });
              }),
            ],
          ),
        ),
      ]),
    );
  }
}
