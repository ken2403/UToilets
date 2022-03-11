import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../.env.dart';
import '../widgets/appbar.dart';
import './map_page.dart';
import './homepage.dart';
import '../Icon/multipurpose_toilet.dart';

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
          items: <int>[1990, 2000, 2010, 2020]
              .map<DropdownMenuItem<int>>((int value) {
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

  // TODO:switchlist
  // function to build custom switch list
  Widget _customSwitch(
    BuildContext context,
    bool value,
    Function(bool) onChanged,
    String title,
    String subtitle,
  ) {
    void Function(bool) _onChanged = onChanged(value);
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
          fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
          color: _displayOtherButton
              ? Theme.of(context).textTheme.bodyText1!.color
              : Theme.of(context).textTheme.bodyText1!.color!.withAlpha(100),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
          color: _displayOtherButton
              ? Theme.of(context).textTheme.bodyText2!.color
              : Theme.of(context).textTheme.bodyText2!.color!.withAlpha(100),
        ),
      ),
      value: value,
      onChanged: _displayOtherButton ? _onChanged : (newValue) {},
    );
  }

  // functon for custom switch list
  void Function(bool) _customOnChanged(bool value) {
    return (newValue) {
      setState(() {
        value = newValue;
      });
    };
  }

  // function to display filterd map when push the floatingActionButton
  Future<void> _displayFilteredMap(BuildContext ctx) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ChosenSex _chosenSex =
        prefs.getInt('sex') == 0 ? ChosenSex.male : ChosenSex.female;
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
    await prefs.setBool('isVacant', _isVacant);
    await prefs.setBool('washlet', _washlet);
    await prefs.setBool('multipurpose', _multipurpose);
    await prefs.setInt('madeYear', _madeYear);
    await prefs.setBool('notRecyclePaper', _notRecyclePaper);
    await prefs.setBool('doublePaper', _doublePaper);
    await prefs.setBool('seatWarmer', _seatWarmer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, SearchPage.title),
      body: Padding(
        padding: pagePadding,
        child: ListView(
          children: <Widget>[
            _customSwitch(
              context,
              _isVacant,
              _customOnChanged,
              '空きあり',
              '個室の空きがあるトイレのみをマップ上に表示',
            ),
            _customSwitch(
              context,
              _washlet,
              _customOnChanged,
              'ウォシュレット',
              'ウォシュレットのあるトイレのみマップ上に表示',
            ),
            _customSwitch(
              context,
              _multipurpose,
              _customOnChanged,
              '多目的トイレ',
              '多目的トイレのみをマップ上に表示',
            ),
            _customSwitch(
              context,
              _notRecyclePaper,
              _customOnChanged,
              '温座',
              '温座があるトイレのみをマップ上に表示',
            ),
            _buildDropdownButton(_madeYear, (int? newValue) {
              setState(() {
                _madeYear = newValue!;
              });
            }),
            _customSwitch(
              context,
              _notRecyclePaper,
              _customOnChanged,
              '再生紙',
              'トイレットペーパーが再生紙でないトイレのみをマップ上に表示',
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
          onPressed: () {
            _displayFilteredMap(context);
            _saveParams ? _paramSaver() : null;
          }),
    );
  }
}
