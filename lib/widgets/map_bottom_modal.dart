import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../.env.dart';

class MapBottomModal extends StatefulWidget {
  /*
    map上のanchorをタップした際に下からせりあがるモーダル．
  */
  // constructor
  const MapBottomModal({Key? key, required this.toiletDataElement})
      : super(key: key);
  final Map<String, dynamic> toiletDataElement;

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

  Widget _buildInfoIcons() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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

  Widget _buildHorizontalView(BuildContext context, int horizontalIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        child: _images[horizontalIndex],
      ),
    );
  }

  Widget _buildHorizontalItem(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.6),
        itemCount: _images.length,
        itemBuilder: (context, horizontalIndex) =>
            _buildHorizontalView(context, horizontalIndex),
      ),
    );
  }

  List<String> _encodeMapToStrlist(Map<int, dynamic> toiletMap) {
    List<String> strList = [];
    toiletMap.forEach((key, value) {
      strList.add(json.encode({key.toString(): value}));
    });
    return strList;
  }

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

  Map<int, dynamic> _loadToilet(SharedPreferences prefs) {
    if (prefs.getStringList('favToilets') == null) {
      Map<int, dynamic> toiletMap = {};
      return toiletMap;
    } else {
      var strList = prefs.getStringList('favToilets');
      return _decodeStrlistToMap(strList!);
    }
  }

  Future<void> _saveToilet(Map<String, dynamic> toiletDataElement) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<int, dynamic> toiletMap = await _loadToilet(prefs);
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
                _buildHorizontalItem(context),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 * 2,
                      child: ElevatedButton(
                        // TODO:onPressed
                        onPressed: () {},
                        child: Text(
                          'このトイレに行く',
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3 * 2,
                      child: ElevatedButton(
                        onPressed: () {
                          _saveToilet(widget.toiletDataElement);
                        },
                        child: Text('お気に入りに保存する',
                            style: Theme.of(context).textTheme.button),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
