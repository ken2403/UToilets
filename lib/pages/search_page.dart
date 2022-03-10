import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './map_page.dart';
import '../Icon/multipurpose_toilet.dart';

enum ChosenSex {
  male,
  female,
}
const radioText = <ChosenSex, String>{
  ChosenSex.male: '男性',
  ChosenSex.female: '女性',
};

class SearchPage extends StatefulWidget {
  /*
    トイレの条件を設定して検索するページ．
    設定した条件の保存もしたり，保存した設定を読み込むことも可能．
    検索後に条件を満たすトイレのみを表示したマップのページに遷移する．
  */
  // static values
  static const String route = '/home/search';
  static const String title = '条件からトイレを探す';
  // constructor
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // set some variables
  ChosenSex _chosenSex = ChosenSex.male;
  bool _isVacant = false;
  bool _washlet = false;
  bool _multipurpose = false;
  int _madeYear = 1900;
  bool _notRecyclePaper = false;
  bool _doublePaper = false;
  bool _seatWarmer = false;
  bool _useSavedParams = false;
  bool _saveParams = false;
  bool _displayOtherButton = true;

  // TODO:見た目を変更
  // widgets that set the date of manufacture
  // 変更された変数をmappageに遷移するときに引き渡す．
  Widget _buildDropdownButton(int madeYear, void Function(int?) update) {
    return Row(
      children: [
        const Text(
          '製造年月日',
        ),
        DropdownButton(
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
        const Text(
          '年以降',
        ),
      ],
    );
  }

  // function to change _chosenSex to selected sex
  void _onRadioSelected(value) {
    setState(() {
      _chosenSex = value;
    });
  }

  // function to display filterd map when push the floatingActionButton
  void _displayFilteredMap(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (context) {
          return MapPage(
            sex: _chosenSex,
            barTitle: '検索結果',
            filters: {
              'isVacant': _isVacant,
              'washlet': _washlet,
              'multipurpose': _multipurpose,
              'madeYear': _madeYear,
              'notRecyclePaper': _notRecyclePaper,
              'doublePaper': _doublePaper,
              'seatWarmer': _seatWarmer,
            },
          );
        },
      ),
    );
  }

  // load parameter
  Future<void> _loadSavedParams() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isVacant') == null) {
      _paramSaver();
    }
    setState(() {
      _chosenSex = prefs.getInt('sex') == 0 ? ChosenSex.male : ChosenSex.female;
      _isVacant = prefs.getBool('isVacant')!;
      _washlet = prefs.getBool('washlet')!;
      _multipurpose = prefs.getBool('multipurpose')!;
      _madeYear = prefs.getInt('madeYear')!;
      _notRecyclePaper = prefs.getBool('notRecyclePaper')!;
      _doublePaper = prefs.getBool('doublePaper')!;
      _seatWarmer = prefs.getBool('seatWarmer')!;
    });
  }

  // save parameter
  Future<void> _paramSaver() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('sex', _chosenSex == ChosenSex.male ? 0 : 1);
    await prefs.setBool('isVacant', _isVacant);
    await prefs.setBool('washlet', _washlet);
    await prefs.setBool('multipurpose', _multipurpose);
    await prefs.setInt('madeYear', _madeYear);
    await prefs.setBool('notRecyclePaper', _notRecyclePaper);
    await prefs.setBool('doublePaper', _doublePaper);
    await prefs.setBool('seatWarmer', _seatWarmer);
  }

  // TODO:switchlist
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          SearchPage.title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Radio(
                value: ChosenSex.male,
                groupValue: _chosenSex,
                onChanged: (value) => _onRadioSelected(value),
              ),
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: Text(radioText[ChosenSex.male]!),
              ),
              Radio(
                value: ChosenSex.female,
                groupValue: _chosenSex,
                onChanged: (value) => _onRadioSelected(value),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20),
                child: Text(radioText[ChosenSex.female]!),
              )
            ],
          ),
          SwitchListTile(
            activeColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTrackColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary.withAlpha(100)
                : Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(100)
                    .withOpacity(0.2),
            inactiveThumbColor: _displayOtherButton
                ? Colors.white
                : Colors.black87.withOpacity(0.2),
            inactiveTrackColor: _displayOtherButton
                ? Colors.black87.withAlpha(100)
                : Colors.black87.withAlpha(100).withOpacity(0.2),
            title: Text('空きあり',
                style: TextStyle(
                    color: _displayOtherButton
                        ? Colors.black87
                        : Colors.black87.withAlpha(100))),
            subtitle: Text(
              '個室の空きがあるトイレのみをマップ上に表示',
              style: TextStyle(
                color: _displayOtherButton
                    ? Colors.black54
                    : Colors.black54.withAlpha(100),
              ),
            ),
            value: _isVacant,
            onChanged: _displayOtherButton
                ? (newValue) {
                    setState(() {
                      _isVacant = newValue;
                    });
                  }
                : (newValue) {},
          ),
          SwitchListTile(
            activeColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTrackColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary.withAlpha(100)
                : Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(100)
                    .withOpacity(0.2),
            inactiveThumbColor: _displayOtherButton
                ? Colors.white
                : Colors.black87.withOpacity(0.2),
            inactiveTrackColor: _displayOtherButton
                ? Colors.black87.withAlpha(100)
                : Colors.black87.withAlpha(100).withOpacity(0.2),
            title: Text('ウォシュレット',
                style: TextStyle(
                    color: _displayOtherButton
                        ? Colors.black87
                        : Colors.black87.withAlpha(100))),
            subtitle: Text(
              'ウォシュレットがあるトイレのみをマップ上に表示',
              style: TextStyle(
                color: _displayOtherButton
                    ? Colors.black54
                    : Colors.black54.withAlpha(100),
              ),
            ),
            value: _washlet,
            onChanged: _displayOtherButton
                ? (newValue) {
                    setState(() {
                      _washlet = newValue;
                    });
                  }
                : (newValue) {},
          ),
          SwitchListTile(
            activeColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTrackColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary.withAlpha(100)
                : Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(100)
                    .withOpacity(0.2),
            inactiveThumbColor: _displayOtherButton
                ? Colors.white
                : Colors.black87.withOpacity(0.2),
            inactiveTrackColor: _displayOtherButton
                ? Colors.black87.withAlpha(100)
                : Colors.black87.withAlpha(100).withOpacity(0.2),
            title: Text('多目的トイレ',
                style: TextStyle(
                    color: _displayOtherButton
                        ? Colors.black87
                        : Colors.black87.withAlpha(100))),
            subtitle: Text(
              '多目的トイレがあるトイレのみをマップ上に表示',
              style: TextStyle(
                color: _displayOtherButton
                    ? Colors.black54
                    : Colors.black54.withAlpha(100),
              ),
            ),
            value: _multipurpose,
            onChanged: _displayOtherButton
                ? (newValue) {
                    setState(() {
                      _multipurpose = newValue;
                    });
                  }
                : (newValue) {},
          ),
          _buildDropdownButton(_madeYear, (int? newValue) {
            setState(() {
              _madeYear = newValue!;
            });
          }),
          SwitchListTile(
            activeColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTrackColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary.withAlpha(100)
                : Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(100)
                    .withOpacity(0.2),
            inactiveThumbColor: _displayOtherButton
                ? Colors.white
                : Colors.black87.withOpacity(0.2),
            inactiveTrackColor: _displayOtherButton
                ? Colors.black87.withAlpha(100)
                : Colors.black87.withAlpha(100).withOpacity(0.2),
            title: Text('再生紙',
                style: TextStyle(
                    color: _displayOtherButton
                        ? Colors.black87
                        : Colors.black87.withAlpha(100))),
            subtitle: Text(
              'トイレットペーパーが再生紙でないトイレのみをマップ上に表示',
              style: TextStyle(
                color: _displayOtherButton
                    ? Colors.black54
                    : Colors.black54.withAlpha(100),
              ),
            ),
            value: _notRecyclePaper,
            onChanged: _displayOtherButton
                ? (newValue) {
                    setState(() {
                      _notRecyclePaper = newValue;
                    });
                  }
                : (newValue) {},
          ),
          SwitchListTile(
            activeColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTrackColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary.withAlpha(100)
                : Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(100)
                    .withOpacity(0.2),
            inactiveThumbColor: _displayOtherButton
                ? Colors.white
                : Colors.black87.withOpacity(0.2),
            inactiveTrackColor: _displayOtherButton
                ? Colors.black87.withAlpha(100)
                : Colors.black87.withAlpha(100).withOpacity(0.2),
            title: Text('ダブルのトイレットペーパー',
                style: TextStyle(
                    color: _displayOtherButton
                        ? Colors.black87
                        : Colors.black87.withAlpha(100))),
            subtitle: Text(
              'トイレットペーパーがダブルのトイレのみをマップ上に表示',
              style: TextStyle(
                color: _displayOtherButton
                    ? Colors.black54
                    : Colors.black54.withAlpha(100),
              ),
            ),
            value: _doublePaper,
            onChanged: _displayOtherButton
                ? (newValue) {
                    setState(() {
                      _doublePaper = newValue;
                    });
                  }
                : (newValue) {},
          ),
          SwitchListTile(
            activeColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            activeTrackColor: _displayOtherButton
                ? Theme.of(context).colorScheme.primary.withAlpha(100)
                : Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha(100)
                    .withOpacity(0.2),
            inactiveThumbColor: _displayOtherButton
                ? Colors.white
                : Colors.black87.withOpacity(0.2),
            inactiveTrackColor: _displayOtherButton
                ? Colors.black87.withAlpha(100)
                : Colors.black87.withAlpha(100).withOpacity(0.2),
            title: Text('温座',
                style: TextStyle(
                    color: _displayOtherButton
                        ? Colors.black87
                        : Colors.black87.withAlpha(100))),
            subtitle: Text(
              '温座があるトイレのみをマップ上に表示',
              style: TextStyle(
                color: _displayOtherButton
                    ? Colors.black54
                    : Colors.black54.withAlpha(100),
              ),
            ),
            value: _seatWarmer,
            onChanged: _displayOtherButton
                ? (newValue) {
                    setState(() {
                      _seatWarmer = newValue;
                    });
                  }
                : (newValue) {},
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: _saveParams,
                    onChanged: _displayOtherButton
                        ? (newValue) {
                            setState(() {
                              _saveParams = newValue!;
                            });
                          }
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'この検索条件を保存する',
                      style: TextStyle(
                          color: _displayOtherButton
                              ? Colors.black87
                              : Colors.black38),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: _useSavedParams,
                    onChanged: (newValue) {
                      setState(() {
                        _useSavedParams = newValue!;
                        if (_useSavedParams) {
                          _loadSavedParams();
                          _displayOtherButton = false;
                          _saveParams = false;
                        } else {
                          _displayOtherButton = true;
                          _saveParams = false;
                        }
                      });
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text('保存した検索条件を使用する'),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.search),
          // when pressing the search button, change the page to filtered map.
          onPressed: () {
            _displayFilteredMap(context);
            _saveParams ? _paramSaver() : null;
          }),
    );
  }
}
