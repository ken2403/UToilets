import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../.env.dart';
import '../pages/mypage/toilet_save_page.dart';

class MapBottomModal extends StatefulWidget {
  /*
    map上のanchorをタップした際に下からせりあがるモーダル．
  */
  // constructor
  const MapBottomModal({
    Key? key,
    required this.toiletDataElement,
    required this.controller,
    required this.pressedGo,
  }) : super(key: key);
  final Map<String, dynamic> toiletDataElement;
  final GoogleMapController controller;
  final Future<void> Function(GoogleMapController, LatLng) pressedGo;

  @override
  State<MapBottomModal> createState() => _MapBottomModalState();
}

class _MapBottomModalState extends State<MapBottomModal> {
  // initialize some variables
  final List<Image> _images = [];

  // function to get image list
  Future<List<Image>> _getImageList(
    BuildContext context,
    String id,
    List<Image> images,
  ) async {
    final manifestContent = await DefaultAssetBundle.of(context)
        .loadString('assets/data/imageManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/images/toilets/$id'))
        .where((String key) => key.contains('.jpg'))
        .toList();
    for (var path in imagePaths) {
      setState(() {
        images.add(Image.asset(path));
      });
    }
    return images;
  }

  Widget _buidInfoIconOne(String label, IconData icon, bool val) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          icon,
          color: val
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.background,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }

  // build toilets information icons
  Widget _buildInfoIcons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        child: PageView(
          controller: PageController(initialPage: 1, viewportFraction: 0.3),
          children: [
            _buidInfoIconOne(
              'washlet',
              Icons.wc,
              widget.toiletDataElement['metadata']['washlet'],
            ),
            _buidInfoIconOne(
              'multipurpose',
              Icons.wc,
              widget.toiletDataElement['metadata']['multipurpose'],
            ),
            _buidInfoIconOne(
              'seat warmer',
              Icons.wc,
              widget.toiletDataElement['metadata']['seatWarmer'],
            ),
            _buidInfoIconOne(
              'double',
              Icons.wc,
              widget.toiletDataElement['metadata']['doublePaper'],
            ),
            _buidInfoIconOne(
              'not recycle',
              Icons.wc,
              widget.toiletDataElement['metadata']['notRecyclePaper'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButons(BuildContext context) {
    return SizedBox(
      height: 45,
      child: PageView(
        controller: PageController(initialPage: 1, viewportFraction: 0.4),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                widget.pressedGo(
                    widget.controller,
                    LatLng(widget.toiletDataElement['lat'],
                        widget.toiletDataElement['lng']));
                Navigator.of(context).pop();
              },
              child: Text(
                'ここへ行く',
                style: TextStyle(
                  color: Theme.of(context).textTheme.button!.color,
                  fontSize: Theme.of(context).textTheme.button!.fontSize! - 3,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              // TODO:6onPressed
              onPressed: () {},
              child: Text(
                '建物の中の\n案内を開始',
                style: TextStyle(
                  color: Theme.of(context).textTheme.button!.color,
                  fontSize: Theme.of(context).textTheme.button!.fontSize! - 3,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                _saveToilet(widget.toiletDataElement);
                _saveConfirm();
              },
              child: Text(
                'お気に入り\nに登録',
                style: TextStyle(
                  color: Theme.of(context).textTheme.button!.color,
                  fontSize: Theme.of(context).textTheme.button!.fontSize! - 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // decode String List that is return value of shared preferences, to Map object
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

  // load String List of shared preferences to toiletMap
  Map<int, dynamic> _loadToilet(SharedPreferences prefs) {
    if (prefs.getStringList('favToilets') == null) {
      Map<int, dynamic> toiletMap = {};
      return toiletMap;
    } else {
      var strList = prefs.getStringList('favToilets');
      return _decodeStrlistToMap(strList!);
    }
  }

  // function to save toilets. If already saved, do not save selected toilet
  Future<void> _saveToilet(Map<String, dynamic> toiletDataElement) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<int, dynamic> toiletMap = _loadToilet(prefs);
    int index = 0;
    toiletMap.forEach((key, value) {
      if (value == toiletDataElement['ID'].toString()) {
        return;
      }
      index++;
    });
    toiletMap.addAll({index: toiletDataElement['ID'].toString()});
    List<String> strList = _encodeMapToStrlist(toiletMap);
    prefs.setStringList('favToilets', strList);
  }

  // show dialog if save button pressed
  void _saveConfirm() {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          title: const Text("お気に入り登録"),
          content: const Text(
              "お気に入りに登録しました．\nマイページ中の${ToiletSavePage.title}から確認できます．"),
          actions: [
            TextButton(
              child: Text(
                "閉じる",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: Theme.of(context).textTheme.button!.fontSize,
                  fontWeight: Theme.of(context).textTheme.button!.fontWeight,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHorizontalView(BuildContext context, int horizontalIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: _images[horizontalIndex],
      ),
    );
  }

  // build PageView of some toilets images
  Widget _buildHorizontalItem(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: PageView.builder(
        controller: PageController(
          initialPage: _images.length >= 2 ? 1 : 0,
          viewportFraction: 0.6,
        ),
        itemCount: _images.length,
        itemBuilder: (context, horizontalIndex) =>
            _buildHorizontalView(context, horizontalIndex),
      ),
    );
  }

  // encode toiletMap to String List for shared preferences
  List<String> _encodeMapToStrlist(Map<int, dynamic> toiletMap) {
    List<String> strList = [];
    toiletMap.forEach((key, value) {
      strList.add(json.encode({key.toString(): value}));
    });
    return strList;
  }

  @override
  void initState() {
    super.initState();
    _getImageList(context, widget.toiletDataElement['ID'].toString(), _images);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 520,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  widget.toiletDataElement['locationJa'] as String,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                _buildInfoIcons(),
                _buildButons(context),
                _buildHorizontalItem(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
