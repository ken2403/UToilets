import 'dart:convert';
import 'dart:async';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  /*
    トイレのデータのjsonファイル(assets/data/toilet.json)から、
    条件を満たすトイレのみをマップ上に表示するWidget.

    Attributes
    ----------
    location : LocationData
      LocationData than has attributes of 'double latitude' and 'doublt longtitude'.
    mapController : Completer<GoogleMapController>
      Controller for a single GoogleMap
  */
  // constructor for filter
  MapWidget(
      {Key? key,
      required this.location,
      required this.mapController,
      required this.filters})
      : _any = false,
        super(key: key);
  // constuctor for display all toilets
  MapWidget.any({Key? key, required this.location, required this.mapController})
      : filters = {
          'multipurpose': false,
          'washlet': false,
          'madeyear': 1900,
          'recyclePaper': false,
          'singlePaper': false,
          'seatWarmer': false,
          'isfiltered': false,
        },
        _any = true,
        super(key: key);

  final LocationData location;
  final Completer<GoogleMapController> mapController;
  Map<String, Object> filters;
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
    //debug
    // print('debug');
    // print(widget.filters['multipurpose']);
    // print(widget.filters['washlet']);
    // print(widget.filters['madeyear']);
    // print(widget.filters['recyclePaper']);
    // print(widget.filters['singlePaper']);
    // print(widget.filters['seatWarmer']);

    // filterのある変数(multipurposeなど)がtureになっていて、かつその変数がfalseのトイレのみスルーしてそうでないトイレは含めるというアルゴリズムに変更した。
    if (widget._any) {
      for (var element in toiletData) {
        _addMarker(element, markers);
      }
    }
    for (var element in toiletData) {
      if (widget.filters['multipurpose'] as bool &&
          !element['metadata']['multipurpose']) {
        continue;
      }
      if (widget.filters['washlet'] as bool &&
          !element['metadata']['washlet']) {
        continue;
      }
      if (widget.filters['madeyear'] as int >=
          element['metadata']['madeYear']) {
        continue;
      }
      if (widget.filters['recyclePaper'] as bool &&
          !element['metadata']['recyclePaper']) {
        continue;
      }
      if (widget.filters['singlePaper'] as bool &&
          !element['metadata']['singlePaper']) {
        continue;
      }
      if (widget.filters['seatWarmer'] as bool &&
          !element['metadata']['seatWarmer']) {
        continue;
      }
      _addMarker(element, markers);
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
