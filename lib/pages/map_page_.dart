import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../model/directions_repository.dart';
import '../model/directions_model.dart';
import './search_page.dart';

class MapPage extends StatefulWidget {
  /*
    条件を満たすトイレの位置をマップ上に表示するページ．
    デフォルトでは全てのトイレの位置をマップ上に表示．
  */
  // static variables
  static const String route = '/map';
  static const String title = '地図からトイレを探す';
  // constructor for filter
  const MapPage(
      {Key? key,
      required this.sex,
      required this.barTitle,
      required this.filters})
      : _any = false,
        super(key: key);
  // constuctor for display all toilets
  MapPage.any({Key? key, required this.sex, required this.barTitle})
      : filters = {
          'isVacant': false,
          'washlet': false,
          'multipurpose': false,
          'madeYear': 1900,
          'notRecyclePaper': false,
          'doublePaper': false,
          'seatWarmer': false,
        },
        _any = true,
        super(key: key);
  // TODO:sex
  final RadioValueSex sex;
  final String barTitle;
  final Map<String, Object> filters;
  final bool _any;

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  // set constants
  final _centerOfUT =
      Position.fromMap({'latitude': 35.71281, 'longitude': 139.76203});
  final String pathToToiletJson = 'assets/data/toilet.json';
  final String pathToVacantInfo = 'assets/data/dummy_isvacant.json';
  // initialize some variables
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  Position? _currentLocation;
  Directions? _directionsInfo;

  // function to get the current location
  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    _currentLocation = _centerOfUT;

    // check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if not enabled, _centerOfUT is set to _currentlocation
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // prompt users to allow location
      permission = await Geolocator.requestPermission();
      // if permission is not granted, _centerOfUT is set to _currentlocation
      if (permission == LocationPermission.denied) return;
    }

    // if all is well, get the user's current location
    _currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // function to initialize the state with current position
  @override
  void initState() {
    super.initState();

    // getting current location
    _getLocation();
  }

  // @override
  // void dispose() {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.dispose();
  //   super.dispose();
  // }

  // function to create a one marker from information of a double toilet
  void _addMarker(Map toiletDataElement, List vacantList, Set markersSet) {
    // display for whether there is a multi-purpose restroom or not
    String multipurpose =
        toiletDataElement['metadata']['multipurpose'] ? 'あり' : 'なし';
    // toilet position
    LatLng toiletPosition =
        LatLng(toiletDataElement['lat'], toiletDataElement['lng']);
    // add marker to markersSet
    setState(
      () {
        markersSet.add(
          Marker(
            markerId: MarkerId(toiletDataElement['location']),
            position: toiletPosition,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              vacantList.any((val) => val)
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: toiletDataElement['locationJa'] + '    ' + 'Tapしてここへ行く',
              snippet: widget.sex == RadioValueSex.all
                  ? '女性洋式:${toiletDataElement['metadata']['femaleBigYou']} 男性洋式:${toiletDataElement['metadata']['maleBigYou']} 多目的トイレ:' +
                      multipurpose
                  : widget.sex == RadioValueSex.male
                      ? '男性洋式:${toiletDataElement['metadata']['maleBigYou']} 小便器:${toiletDataElement['metadata']['maleSmall']} 多目的トイレ:' +
                          multipurpose
                      : '女性洋式:${toiletDataElement['metadata']['femaleBigYou']} 多目的トイレ:' +
                          multipurpose,
              // TODO: tap InfoWindow
              onTap: () => print('tap info window'),
            ),
            onTap: () => _onTapAnchor(toiletPosition),
          ),
        );
      },
    );
  }

  // function that called when the map anchor is tapped
  Future<void> _onTapAnchor(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: position,
      zoom: 17,
      tilt: 50.0,
    )));
  }

  // function to extract the toilets that match the setting conditions from .json
  Future getMarkers(Set<Marker> markers) async {
    // get toilet data from json and parse to List
    String loadData = await rootBundle.loadString(pathToToiletJson);
    final jsonResponse = json.decode(loadData);
    final List toiletData = jsonResponse['toiletData'];
    // get vacant info
    String loadVacant = await rootBundle.loadString(pathToVacantInfo);
    final jsonVacant = json.decode(loadVacant);
    // filterのある変数(multipurposeなど)がtureになっていて、かつその変数がfalseのトイレのみスルーしてそうでないトイレは含めるというアルゴリズムに変更した。
    if (widget._any) {
      for (var element in toiletData) {
        // TODO:sex
        List vacantList = jsonVacant[element['ID'].toString()]["maleBigYou"] +
            jsonVacant[element['ID'].toString()]["femaleBigYou"];
        _addMarker(element, vacantList, markers);
      }
    } else {
      for (var element in toiletData) {
        List vacantList = widget.sex == RadioValueSex.male
            ? jsonVacant[element['ID'].toString()]["maleBigYou"]
            : jsonVacant[element['ID'].toString()]["femaleBigYou"];
        if (widget.filters['isVacant'] as bool &&
            !vacantList.any((val) => val)) {
          continue;
        }
        if (widget.filters['washlet'] as bool &&
            !element['metadata']['washlet']) {
          continue;
        }
        if (widget.filters['multipurpose'] as bool &&
            !element['metadata']['multipurpose']) {
          continue;
        }
        if (widget.filters['madeYear'] as int >=
            element['metadata']['madeYear']) {
          continue;
        }
        if (widget.filters['notRecyclePaper'] as bool &&
            !element['metadata']['notRecyclePaper']) {
          continue;
        }
        if (widget.filters['doublePaper'] as bool &&
            !element['metadata']['doublePaper']) {
          continue;
        }
        if (widget.filters['seatWarmer'] as bool &&
            !element['metadata']['seatWarmer']) {
          continue;
        }
        _addMarker(element, vacantList, markers);
      }
    }
  }

  // functon called when tapped floatingActionButton
  Future<void> _goNearest(Set<Marker> markers) async {
    final GoogleMapController controller = await _controller.future;
    if (_currentLocation == _centerOfUT) {
      return;
    } else {
      double minMeters = 5.0e3;
      Marker minMarker = markers.first;
      for (var element in markers) {
        double distanceInMeters = Geolocator.distanceBetween(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          element.position.latitude,
          element.position.longitude,
        );
        if (minMeters > distanceInMeters) {
          minMeters = distanceInMeters;
          minMarker = element;
        }
      }
      // show dialog if distance from university is too far
      if (minMeters >= 5.0e3) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return AlertDialog(
              title: const Text("トイレが遠すぎます！"),
              content: const Text("本郷キャンパスの近くで試してください"),
              actions: [
                TextButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }
      // show routes if they are close enough to the university
      else {
        // switch the center of view point to the current location
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    _currentLocation!.latitude, _currentLocation!.longitude),
                zoom: 17,
                tilt: 50.0),
          ),
        );
        // show directions to the nearest marker
        final directions = await DirectionsRepository().getDirections(
            origin: LatLng(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
            ),
            destination: LatLng(
              minMarker.position.latitude,
              minMarker.position.longitude,
            ));
        if (directions != null) {
          setState(() => _directionsInfo = directions);
        } else {
          _directionsInfo = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getMarkers(_markers);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          widget.barTitle,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!.latitude,
                  _currentLocation!.longitude,
                ),
                zoom: 16.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              polylines: {
                if (_directionsInfo != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _directionsInfo!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  )
              }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goNearest(_markers),
        label: const Text(
          '今すぐ最寄りへ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(
          Icons.directions_run,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
