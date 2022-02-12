import 'dart:convert';
import 'dart:async';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  /*
    トイレのデータのjsonファイル(assets/data/toilet.json)から、
    条件を満たすトイレのみをマップ上に表示するWidget
    LocationDataとmapControllerを渡して初期化するようになってるのは、それ以外に方法が思いつかなかったからなので、どうしたらいいか(アプリのデザインも含めて)一緒に考えて欲しい
    今のところはウォシュレットの有無と製造年月日のみでフィルター可能(情報追加してくれてOK)

    Attributes
    ----------
    location : LocationData
      LocationData than has attributes of 'double latitude' and 'doublt longtitude'.
    mapController : Completer<GoogleMapController>
      Controller for a single GoogleMap
    washletAvailable : bool
      filter of washlet availability.
    madeYear : int
      filter of made year.
  */
  // 検索時のフィルター用のコンストラクター
  const MapWidget(
      {Key? key,
      required this.location,
      required this.mapController,
      required this.washletAvailable,
      required this.madeYear})
      : _any = false,
        super(key: key);
  // 全部のリストを表示する用のコンストラクター
  const MapWidget.any(
      {Key? key, required this.location, required this.mapController})
      : washletAvailable = false,
        madeYear = 2020,
        _any = true,
        super(key: key);

  final LocationData location;
  final Completer<GoogleMapController> mapController;
  final bool washletAvailable;
  final int madeYear;
  final bool _any;

  @override
  _MapMarkersState createState() => _MapMarkersState();
}

class _MapMarkersState extends State<MapWidget> {
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

  // function to extract the toilets that match the conditions from .json
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
        if (widget.madeYear <= element['metadata']['madeYear']) {
          _addMarker(element, markers);
        }
      } else if (!(widget.washletAvailable)) {
        if (widget.madeYear <= element['metadata']['madeYear']) {
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
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.location.latitude!, widget.location.longitude!),
        zoom: 16.5,
      ),
      onMapCreated: (GoogleMapController controller) {
        widget.mapController.complete(controller);
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: _markers,
    );
  }
}
