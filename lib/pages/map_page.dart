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
    bottomNavigationBarのindex=0から遷移できるページでは，全てのトイレの位置をマップ上に表示．
    'lib/pages/search_page.dart'から遷移するページでは，検索条件にマッチするトイレのみっマップ上に表示する．
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
  final ChosenSex sex;
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
  final String _pathToToiletJson = 'assets/data/toilet.json';
  final String _pathToVacantInfo = 'assets/data/dummy_isvacant.json';
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
  // TODO:dispose
  // @override
  // void dispose() {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.dispose();
  //   super.dispose();
  // }

  // function to create a one marker from information of a double toilet
  void _addMarker(Map toiletDataElement, List vacantList, Set markersSet) {
    String multipurpose =
        toiletDataElement['metadata']['multipurpose'] ? 'あり' : 'なし';
    LatLng toiletPosition =
        LatLng(toiletDataElement['lat'], toiletDataElement['lng']);
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
            // tap anchor
            onTap: () => _tapAnchorOrInfoWindow(toiletPosition),
            infoWindow: InfoWindow(
              title: toiletDataElement['locationJa'] + '    ' + 'Tapしてここへ行く',
              snippet: widget.sex == ChosenSex.all
                  ? '女性洋式:${toiletDataElement['metadata']['femaleBigYou']} 男性洋式:${toiletDataElement['metadata']['maleBigYou']} 多目的トイレ:' +
                      multipurpose
                  : widget.sex == ChosenSex.male
                      ? '男性洋式:${toiletDataElement['metadata']['maleBigYou']} 小便器:${toiletDataElement['metadata']['maleSmall']} 多目的トイレ:' +
                          multipurpose
                      : '女性洋式:${toiletDataElement['metadata']['femaleBigYou']} 多目的トイレ:' +
                          multipurpose,
              // tap info window
              onTap: () => _tapAnchorOrInfoWindow(toiletPosition),
            ),
          ),
        );
      },
    );
  }

  // function that called when the map anchor of info window is tapped
  Future<void> _tapAnchorOrInfoWindow(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    position = LatLng(position.latitude - 0.0013, position.longitude);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: position,
      zoom: 17.5,
      tilt: 50.0,
    )));
    await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        // TODO:モーダルの中身
        return Container();
      },
    );
  }

  // function to extract the toilets that match the setting conditions from .json
  Future getMarkers(Set<Marker> markers) async {
    // get toilet data from json and parse to List
    String loadData = await rootBundle.loadString(_pathToToiletJson);
    final jsonResponse = json.decode(loadData);
    final List toiletData = jsonResponse['toiletData'];
    // get vacant info
    String loadVacant = await rootBundle.loadString(_pathToVacantInfo);
    final jsonVacant = json.decode(loadVacant);
    // filterのある変数(multipurposeなど)がtureになっていて，かつその変数がfalseのトイレのみスルーしてそうでないトイレは含めるというアルゴリズムに変更した．
    if (widget._any) {
      for (var element in toiletData) {
        // TODO:sex
        List vacantList = jsonVacant[element['ID'].toString()]["maleBigYou"] +
            jsonVacant[element['ID'].toString()]["femaleBigYou"];
        _addMarker(element, vacantList, markers);
      }
    } else {
      for (var element in toiletData) {
        List vacantList = widget.sex == ChosenSex.male
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
    // if the current location cannot be obtained, ask permission
    if (_currentLocation == _centerOfUT) {
      showDialog(
        context: context,
        useRootNavigator: false,
        barrierDismissible: true,
        builder: (_) {
          return AlertDialog(
            title: const Text("現在地が取得できませんでした"),
            content: const Text("位置情報の使用を許可しますか"),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                // TODO:okを押したらpermissonを表示
                onPressed: () => {},
              ),
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
    // if the current location is valid
    else {
      // if there is no markers that meet the criteria, instruct the user to redo the search
      if (markers.isEmpty) {
        showDialog(
          context: context,
          useRootNavigator: false,
          barrierDismissible: true,
          builder: (_) {
            return AlertDialog(
              title: const Text("条件を満たすトイレはありません"),
              content: const Text("もう一度条件を設定してください"),
              actions: [
                TextButton(
                  child: Text(
                    "もう一度検索",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
                TextButton(
                  child: Text(
                    "Close",
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
      // if there is a marker, calculate the distance between current locatin and the nearest toilet
      else {
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
            useRootNavigator: false,
            barrierDismissible: true,
            builder: (_) {
              return AlertDialog(
                title: const Text("トイレが遠すぎます！"),
                content: const Text("本郷キャンパスの近くで試してください"),
                actions: [
                  TextButton(
                    child: Text(
                      "Close",
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
                    color: Colors.redAccent,
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
