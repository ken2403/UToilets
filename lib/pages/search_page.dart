import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../.env.dart';
import '../widgets/appbar.dart';
import './map_page.dart';
import './homepage.dart';

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
  bool _isVacant = false;
  bool _washlet = false;
  bool _multipurpose = false;
  int _madeYear = 1990;
  bool _notRecyclePaper = false;
  bool _doublePaper = false;
  bool _seatWarmer = false;
  bool _useSavedParams = false;
  bool _saveParams = false;
  bool _displayOtherButton = true;
  ChosenSex _chosenSex = ChosenSex.male;

  // TODO:4見た目を変更
  // widgets that set the date of manufacture
  // 変更された変数をmappageに遷移するときに引き渡す．
  Widget _buildDropdownButton(
      BuildContext context, int madeYear, void Function(int?) update) {
    return ListTile(
      title: Text(
        '製造年',
        style: TextStyle(
          fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
          fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
          color: _displayOtherButton
              ? Theme.of(context).textTheme.bodyText1!.color
              : Theme.of(context).textTheme.bodyText1!.color!.withAlpha(100),
        ),
      ),
      subtitle: Text(
        '設定年以降に作られたトイレのみをマップ上に表示',
        style: TextStyle(
          fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
          fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
          color: _displayOtherButton
              ? Theme.of(context).textTheme.bodyText2!.color
              : Theme.of(context).textTheme.bodyText2!.color!.withAlpha(100),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: DropdownButton(
                value: madeYear,
                icon: const Icon(Icons.unfold_more_sharp),
                elevation: 16,
                onChanged: _displayOtherButton ? update : (newValue) {},
                items: <int>[1970, 1980, 1990, 2000, 2010, 2020]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        color: _displayOtherButton
                            ? Theme.of(context).textTheme.bodyText1!.color
                            : Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withAlpha(100),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Text(
            '年',
            style: TextStyle(
              color: _displayOtherButton
                  ? Theme.of(context).textTheme.bodyText1!.color
                  : Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .color!
                      .withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }

  // function to build custom switch list
  Widget _customSwitch(
    BuildContext context,
    bool value,
    void Function(bool) onChanged,
    String title,
    String subtitle,
  ) {
    return SwitchListTile(
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
      inactiveThumbColor:
          _displayOtherButton ? Colors.white : Colors.black87.withOpacity(0.2),
      inactiveTrackColor: _displayOtherButton
          ? Theme.of(context).unselectedWidgetColor.withOpacity(0.4)
          : Theme.of(context).unselectedWidgetColor.withOpacity(0.2),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
          fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
          color: _displayOtherButton
              ? Theme.of(context).textTheme.bodyText1!.color
              : Theme.of(context).textTheme.bodyText1!.color!.withAlpha(100),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
          fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
          color: _displayOtherButton
              ? Theme.of(context).textTheme.bodyText2!.color
              : Theme.of(context).textTheme.bodyText2!.color!.withAlpha(100),
        ),
      ),
      value: value,
      onChanged: _displayOtherButton ? onChanged : (newValue) {},
    );
  }

  //
  Future<void> _setSex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _chosenSex = prefs.getInt('sex') == 0 ? ChosenSex.male : ChosenSex.female;
    });
  }

  // function to display filterd map when push the floatingActionButton
  Future<void> _displayFilteredMap(BuildContext ctx) async {
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
      await _paramSaver(prefs);
    }
    setState(() {
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
  Future<void> _paramSaver(SharedPreferences prefs) async {
    await prefs.setBool('isVacant', _isVacant);
    await prefs.setBool('washlet', _washlet);
    await prefs.setBool('multipurpose', _multipurpose);
    await prefs.setInt('madeYear', _madeYear);
    await prefs.setBool('notRecyclePaper', _notRecyclePaper);
    await prefs.setBool('doublePaper', _doublePaper);
    await prefs.setBool('seatWarmer', _seatWarmer);
  }

  @override
  void initState() {
    super.initState();
    _loadSavedParams();
  }

  @override
  Widget build(BuildContext context) {
    _setSex();
    return Scaffold(
      appBar: customAppbar(context, SearchPage.title),
      body: Padding(
        padding: pagePadding,
        child: ListView(
          children: <Widget>[
            _customSwitch(
              context,
              _isVacant,
              (bool val) {
                setState(() {
                  _isVacant = val;
                });
              },
              '空きあり',
              '個室の空きがあるトイレのみをマップ上に表示',
            ),
            _customSwitch(
              context,
              _washlet,
              (bool val) {
                setState(() {
                  _washlet = val;
                });
              },
              'ウォシュレット',
              'ウォシュレットのあるトイレのみをマップ上に表示',
            ),
            _customSwitch(
              context,
              _multipurpose,
              (bool val) {
                setState(() {
                  _multipurpose = val;
                });
              },
              '多目的トイレ',
              '多目的トイレのみをマップ上に表示',
            ),
            _customSwitch(
              context,
              _seatWarmer,
              (bool val) {
                setState(() {
                  _seatWarmer = val;
                });
              },
              '温座',
              '温座があるトイレのみをマップ上に表示',
            ),
            _customSwitch(
              context,
              _doublePaper,
              (bool val) {
                setState(() {
                  _doublePaper = val;
                });
              },
              'ダブル',
              'トイレットペーパーがダブルのトイレのみをマップに表示',
            ),
            _customSwitch(
              context,
              _notRecyclePaper,
              (bool val) {
                setState(() {
                  _notRecyclePaper = val;
                });
              },
              '再生紙',
              'トイレットペーパーが再生紙でないトイレのみをマップ上に表示',
            ),
            _buildDropdownButton(context, _madeYear, (int? newValue) {
              setState(() {
                _madeYear = newValue!;
              });
            }),
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
                                ? Theme.of(context).textTheme.bodyText1!.color
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
                      child: Text(
                        '保存した検索条件を使用する',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.search,
          color: Theme.of(context).textTheme.button!.color,
        ),
        // when pressing the search button, change the page to filtered map.
        onPressed: () async {
          _displayFilteredMap(context);
          if (_saveParams) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            _paramSaver(prefs);
          }
        },
      ),
    );
  }
}
