import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../.env.dart';
import '../homepage.dart';
import '../../widgets/appbar.dart';

class SettingPage extends StatefulWidget {
  /*
    初期設定を後から変更するページ．
  */
  // static values
  static const String title = '設定';
  // constructor
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // set some constants
  final radioText = <ChosenSex, String>{
    ChosenSex.male: '男性',
    ChosenSex.female: '女性',
  };
  // set some variables
  ChosenSex? _chosenSex;

  // function to change _chosenSex to selected sex
  void _onRadioSelected(value) {
    setState(() {
      _chosenSex = value;
    });
  }

  // load saved settings
  Future<void> _loadSavedParams() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _chosenSex = prefs.getInt('sex') == 0 ? ChosenSex.male : ChosenSex.female;
    });
  }

  // save setting
  Future<void> _paramSaver() async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt('sex', _chosenSex == ChosenSex.male ? 0 : 1);
  }

  @override
  void initState() {
    _loadSavedParams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, SettingPage.title),
      body: Padding(
        padding: pagePadding,
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        '性別を変更',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Radio(
                      value: ChosenSex.male,
                      groupValue: _chosenSex,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) => _onRadioSelected(value),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        radioText[ChosenSex.male]!,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Radio(
                      value: ChosenSex.female,
                      groupValue: _chosenSex,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) => _onRadioSelected(value),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        radioText[ChosenSex.female]!,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5 * 3,
                      child: Text(
                        '位置情報の設定を変更',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          openAppSettings();
                        },
                        child: Text(
                          '設定を開く',
                          style: Theme.of(context).textTheme.bodyText1,
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          '保存する',
          style: Theme.of(context).textTheme.button,
        ),
        onPressed: () {
          _paramSaver();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }
}
