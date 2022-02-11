import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  /*
    トイレのデータのjsonファイル(assets/data/toilet.json)から、
    条件を満たすトイレのみをマップ上に表示するWidget
    今のところはウォシュレットの有無と製造年月日のみでフィルター可能(情報追加してくれてOK)
  */
  // 検索時のフィルター用のコンストラクター
  const MapWidget(
      {Key? key, required this.washletAvailable, required this.madeDate})
      : _any = false,
        super(key: key);
  // 全部のリストを表示する用のコンストラクター
  const MapWidget.any({Key? key})
      : washletAvailable = false,
        madeDate = 2020,
        _any = true,
        super(key: key);

  final bool washletAvailable;
  final int madeDate;
  final bool _any;

  @override
  _MapMarkersState createState() => _MapMarkersState();
}

class _MapMarkersState extends State<MapWidget> {
  static const CameraPosition _initialCenterPosition = CameraPosition(
    target: LatLng(35.71292139692912, 139.7620104550409),
    zoom: 16.4746,
  );
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  void _addMarker(Map toiletDataElement, Set markersSet) {
    setState(() {
      markersSet.add(
        Marker(
          markerId: MarkerId(toiletDataElement['location']),
          position: LatLng(toiletDataElement['lat'], toiletDataElement['lng']),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: toiletDataElement['locationJa'],
            snippet:
                'Female:${toiletDataElement['metadata']['femaleBig']}  Male:${toiletDataElement['metadata']['maleSmall']}',
            // TODO: tap InfoWindow
            onTap: () => print('tap info window'),
          ),
          // TODO: tap anchor
          onTap: () => print('tap anchor'),
        ),
      );
    });
  }

  // データのjsonファイルから条件のトイレのみを抽出する関数
  Future getMarkers(Set<Marker> markers) async {
    String loadData = await rootBundle.loadString('assets/data/toilet.json');
    final jsonResponse = json.decode(loadData);
    final List toiletData = jsonResponse['toiletData'];

    if (widget._any) {
      for (var element in toiletData) {
        _addMarker(element, markers);
      }
    }
    for (var element in toiletData) {
      if (widget.washletAvailable && element['metadata']['washlet']) {
        if (widget.madeDate <= element['metadata']['madeDate']) {
          _addMarker(element, markers);
        }
      } else if (!(widget.washletAvailable)) {
        if (widget.madeDate <= element['metadata']['madeDate']) {
          _addMarker(element, markers);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getMarkers(_markers);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _initialCenterPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
    );
  }
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
