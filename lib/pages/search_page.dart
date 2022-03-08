import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import './map_page_.dart';
import './home_drawer.dart';
import '../Icon/multipurpose_toilet.dart';

enum RadioValueSex {
  male,
  female,
  all,
}
const radioText = <RadioValueSex, String>{
  RadioValueSex.male: '男性',
  RadioValueSex.female: '女性',
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
  // set some variables
  RadioValueSex _chosenSex = RadioValueSex.male;
  bool isVacant = false;
  bool washlet = false;
  bool multipurpose = false;
  int madeYear = 1900;
  bool notRecyclePaper = false;
  bool doublePaper = false;
  bool seatWarmer = false;
  bool useSavedParams = false;
  bool saveParams = false;
  bool displaySaveButton = true;
  final String pathToParamJson = 'assets/data/saved_params.json';

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
              'isVacant': isVacant,
              'washlet': washlet,
              'multipurpose': multipurpose,
              'madeYear': madeYear,
              'notRecyclePaper': notRecyclePaper,
              'doublePaper': doublePaper,
              'seatWarmer': seatWarmer,
            },
          );
        },
      ),
    );
  }

  Future<void> _loadSavedParams() async {
    String loadData = await rootBundle.loadString(pathToParamJson);
    final jsonResponse = json.decode(loadData);
    setState(() {
      _chosenSex = jsonResponse['sex'] == 'male'
          ? RadioValueSex.male
          : RadioValueSex.female;
      isVacant = jsonResponse['isVacant'];
      washlet = jsonResponse['washlet'];
      multipurpose = jsonResponse['multipurpose'];
      madeYear = jsonResponse['madeYear'];
      notRecyclePaper = jsonResponse['notRecyclePaper'];
      doublePaper = jsonResponse['doublePaper'];
      seatWarmer = jsonResponse['seatWarmer'];
    });
  }

  Future<void> _saveParams() async {
    var saveData = {
      "sex": _chosenSex == RadioValueSex.male ? "male" : "female",
      "isVacant": isVacant,
      "washlet": washlet,
      "multipurpose": multipurpose,
      "madeYear": madeYear,
      "notRecyclePaper": notRecyclePaper,
      "doublePaper": doublePaper,
      "seatWarmer": seatWarmer,
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
                value: RadioValueSex.male,
                groupValue: _chosenSex,
                onChanged: (value) => _onRadioSelected(value),
              ),
              Container(
                padding: const EdgeInsets.only(right: 15),
                child: Text(radioText[RadioValueSex.male]!),
              ),
              Radio(
                value: RadioValueSex.female,
                groupValue: _chosenSex,
                onChanged: (value) => _onRadioSelected(value),
              ),
              Container(
                padding: const EdgeInsets.only(right: 20),
                child: Text(radioText[RadioValueSex.female]!),
              )
            ],
          ),
          SwitchListTile(
            title: const Text('空きあり'),
            subtitle: const Text('個室の空きがあるトイレのみをマップ上に表示'),
            value: isVacant,
            onChanged: (newValue) {
              setState(() {
                isVacant = newValue;
              });
            },
          ),
          SwitchListTile(
            title: const Text('ウォシュレット'),
            subtitle: const Text('ウォシュレットがあるトイレのみをマップ上に表示'),
            value: washlet,
            onChanged: (newValue) {
              setState(() {
                washlet = newValue;
              });
            },
          ),
          SwitchListTile(
            secondary: const Icon(multipurpose_toilet.wheelchair),
            title: const Text('多目的トイレ'),
            subtitle: const Text('多目的トイレがあるトイレのみをマップ上に表示'),
            value: multipurpose,
            onChanged: (newValue) {
              setState(() {
                multipurpose = newValue;
              });
            },
          ),
          _buildDropdownButton(madeYear, (int? newValue) {
            setState(() {
              madeYear = newValue!;
            });
          }),
          SwitchListTile(
            title: const Text('再生紙'),
            subtitle: const Text('トイレットペーパーが再生紙ではないトイレのみをマップ上に表示'),
            value: notRecyclePaper,
            onChanged: (newValue) {
              setState(() {
                notRecyclePaper = newValue;
              });
            },
          ),
          SwitchListTile(
            title: const Text('ダブルのトイレットペーパー'),
            subtitle: const Text('トイレットペーパーがダブルのトイレのみをマップ上に表示'),
            value: doublePaper,
            onChanged: (newValue) {
              setState(() {
                doublePaper = newValue;
              });
            },
          ),
          SwitchListTile(
            title: const Text('温座'),
            subtitle: const Text('温座があるトイレのみをマップ上に表示'),
            value: seatWarmer,
            onChanged: (newValue) {
              setState(() {
                seatWarmer = newValue;
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
                    value: useSavedParams,
                    onChanged: (newValue) {
                      setState(() {
                        useSavedParams = newValue!;
                        if (useSavedParams) {
                          _loadSavedParams();
                          displaySaveButton = false;
                          saveParams = false;
                        } else {
                          displaySaveButton = true;
                          saveParams = false;
                        }
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('保存した検索条件を使用する'),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: saveParams,
                    onChanged: displaySaveButton
                        ? (newValue) {
                            setState(() {
                              saveParams = newValue!;
                            });
                          }
                        : null,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'この検索条件を保存する',
                      style: TextStyle(
                          color: displaySaveButton
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
            saveParams ? _saveParams() : null;
          }),
    );
  }
}
