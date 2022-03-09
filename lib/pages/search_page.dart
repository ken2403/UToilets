import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import './map_page.dart';
import './home_drawer.dart';
import '../Icon/multipurpose_toilet.dart';

enum ChosenSex {
  male,
  female,
  all,
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
  // static variables
  static const String route = '/search';
  static const String title = '条件からトイレを探す';
  // constructor
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // set constants
  final String _pathToParamJson = 'assets/data/saved_params.json';
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
  bool _displaySaveButton = true;

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

  Future<void> _loadSavedParams() async {
    String loadData = await rootBundle.loadString(_pathToParamJson);
    final jsonResponse = json.decode(loadData);
    setState(() {
      _chosenSex =
          jsonResponse['sex'] == 'male' ? ChosenSex.male : ChosenSex.female;
      _isVacant = jsonResponse['isVacant'];
      _washlet = jsonResponse['washlet'];
      _multipurpose = jsonResponse['multipurpose'];
      _madeYear = jsonResponse['madeYear'];
      _notRecyclePaper = jsonResponse['notRecyclePaper'];
      _doublePaper = jsonResponse['doublePaper'];
      _seatWarmer = jsonResponse['seatWarmer'];
    });
  }

  Future<void> _saveParamsTonJson() async {
    var saveData = {
      "sex": _chosenSex == ChosenSex.male ? "male" : "female",
      "isVacant": _isVacant,
      "washlet": _washlet,
      "multipurpose": _multipurpose,
      "madeYear": _madeYear,
      "notRecyclePaper": _notRecyclePaper,
      "doublePaper": _doublePaper,
      "seatWarmer": _seatWarmer,
    };
    var jsonText = jsonEncode(saveData);
    // TODO:json 保存
    // Directory appDocDir = await getLibraryDirectory();
    // var jsonPath = join(appDocDir.path, pathToParamJson);
    // await File(jsonPath).writeAsString(jsonText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const HomeDrawer(),
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
            title: const Text('空きあり'),
            subtitle: const Text('個室の空きがあるトイレのみをマップ上に表示'),
            value: _isVacant,
            onChanged: (newValue) {
              setState(() {
                _isVacant = newValue;
              });
            },
          ),
          SwitchListTile(
            title: const Text('ウォシュレット'),
            subtitle: const Text('ウォシュレットがあるトイレのみをマップ上に表示'),
            value: _washlet,
            onChanged: (newValue) {
              setState(() {
                _washlet = newValue;
              });
            },
          ),
          SwitchListTile(
            secondary: const Icon(MultipurposeToilet.wheelchair),
            title: const Text('多目的トイレ'),
            subtitle: const Text('多目的トイレがあるトイレのみをマップ上に表示'),
            value: _multipurpose,
            onChanged: (newValue) {
              setState(() {
                _multipurpose = newValue;
              });
            },
          ),
          _buildDropdownButton(_madeYear, (int? newValue) {
            setState(() {
              _madeYear = newValue!;
            });
          }),
          SwitchListTile(
            title: const Text('再生紙'),
            subtitle: const Text('トイレットペーパーが再生紙ではないトイレのみをマップ上に表示'),
            value: _notRecyclePaper,
            onChanged: (newValue) {
              setState(() {
                _notRecyclePaper = newValue;
              });
            },
          ),
          SwitchListTile(
            title: const Text('ダブルのトイレットペーパー'),
            subtitle: const Text('トイレットペーパーがダブルのトイレのみをマップ上に表示'),
            value: _doublePaper,
            onChanged: (newValue) {
              setState(() {
                _doublePaper = newValue;
              });
            },
          ),
          SwitchListTile(
            title: const Text('温座'),
            subtitle: const Text('温座があるトイレのみをマップ上に表示'),
            value: _seatWarmer,
            onChanged: (newValue) {
              setState(() {
                _seatWarmer = newValue;
              });
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                          _displaySaveButton = false;
                          _saveParams = false;
                        } else {
                          _displaySaveButton = true;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: _saveParams,
                    onChanged: _displaySaveButton
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
                          color: _displaySaveButton
                              ? Colors.black87
                              : Colors.black38),
                    ),
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
            _saveParams ? _saveParamsTonJson() : null;
          }),
    );
  }
}
