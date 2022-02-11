import 'package:flutter/material.dart';

import '../widgets/map_widget.dart';

class MapPage extends StatefulWidget {
  /*
    デフォルトでは、全てのトイレのリストをマップ上に表示
  */
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MapWidget.any(),
    );
  }
}
