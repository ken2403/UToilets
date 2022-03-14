import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../.env.dart';
import '../../widgets/appbar.dart';

class ToiletSavePage extends StatefulWidget {
  /*
    保存したトイレの情報確認するページ．
  */
  // static values
  static const String title = 'お気に入りのトイレ';
  // constructor
  const ToiletSavePage({Key? key}) : super(key: key);

  @override
  State<ToiletSavePage> createState() => _ToiletSavePageState();
}

class _ToiletSavePageState extends State<ToiletSavePage> {
  // set constants
  final String _pathToToiletJson = 'assets/data/toilet.json';
  // set some variables
  List<String> toiletIDs = [];
  List<Map<String, dynamic>> toiletList = [];

  // load String List of shared preferences (toiletIDs)
  Future<void> _loadToilets(List<String> _toiletIDs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('favToilets') != null) {
      var strList = prefs.getStringList('favToilets');
      setState(() {
        _toiletIDs.addAll(strList!);
      });
    }
  }

  // function to save toilets. If already saved, do not save selected toilet
  Future<void> _saveToilets(List<String> _toiletIDs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favToilets', _toiletIDs);
  }

  Future<Map<String, dynamic>?> _getToilets(int id) async {
    // get toilet data from json and parse to List
    String loadData = await rootBundle.loadString(_pathToToiletJson);
    final jsonResponse = json.decode(loadData);
    final List toiletData = jsonResponse['toiletData'];
    for (var element in toiletData) {
      if (element['ID'] == id) {
        return element;
      }
    }
  }

  // function to get toilet data from json and saved IDs
  Future<void> _getToiletsList(
    List<String> _toiletIDs,
    List<Map<String, dynamic>> _toiletList,
  ) async {
    for (var id in _toiletIDs) {
      int idInt = int.parse(id);
      var toiletElement = await _getToilets(idInt);
      setState(() {
        _toiletList.add(toiletElement!);
      });
    }
  }

  void _removeToilet(
    int index,
    List<Map<String, dynamic>> _toiletList,
    List<String> _toiletIDs,
  ) {
    setState(() {
      _toiletIDs.remove(_toiletList[index]['ID'].toString());
      _toiletList.removeAt(index);
      Future(() async {
        _saveToilets(toiletIDs);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      await _loadToilets(toiletIDs);
      _getToiletsList(toiletIDs, toiletList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context, ToiletSavePage.title),
        body: toiletList.isNotEmpty
            ? Padding(
                padding: pagePadding,
                child: ListView.builder(
                  itemCount: toiletList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            toiletList[index]['locationJa'] as String,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          TextButton(
                            onPressed: () async {
                              _removeToilet(index, toiletList, toiletIDs);
                            },
                            child: Text(
                              '削除',
                              style: TextStyle(
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .fontFamily,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .fontSize,
                                color: Colors.red.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Padding(
                  padding: pagePadding,
                  child: Text(
                    '保存されたトイレはありません',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ));
  }
}
