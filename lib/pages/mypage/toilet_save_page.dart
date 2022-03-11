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
  static const String title = '保存したトイレ';
  // constructor
  const ToiletSavePage({Key? key}) : super(key: key);

  @override
  State<ToiletSavePage> createState() => _ToiletSavePageState();
}

class _ToiletSavePageState extends State<ToiletSavePage> {
  // set constants
  final String _pathToToiletJson = 'assets/data/toilet.json';
  // set some variables
  Map<int, dynamic> toiletMap = {};
  List<Map<String, dynamic>> toiletList = [];

  Map<int, dynamic> _decodeStrlistToMap(List<String> strList) {
    Map<String, dynamic> strMap = {};
    for (var str in strList) {
      strMap.addAll(json.decode(str));
    }
    Map<int, dynamic> toiletMap = {};
    strMap.forEach((key, value) {
      toiletMap.addAll({int.parse(key): value});
    });
    return toiletMap;
  }

  Future<void> _loadToilet(Map<int, dynamic> _toiletMap) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('favToilets') != null) {
      var strList = prefs.getStringList('favToilets');
      setState(() {
        _toiletMap.addAll(_decodeStrlistToMap(strList!));
      });
    }
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

  void _getToiletList(
    Map<int, dynamic> _toiletMap,
    List<Map<String, dynamic>> _toiletList,
  ) {
    toiletMap.forEach((key, value) async {
      var toiletElement = await _getToilets(int.parse(_toiletMap[key]));
      setState(() {
        _toiletList.add(toiletElement!);
      });
    });
  }

  // TODO:保存を反映
  @override
  void initState() {
    _loadToilet(toiletMap);
    _getToiletList(toiletMap, toiletList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context, ToiletSavePage.title),
        body: toiletList.isNotEmpty
            ? ListView.builder(
                itemCount: toiletList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 0,
                    child: Text(
                      toiletList[index]['locationJa'] as String,
                    ),
                  );
                },
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
