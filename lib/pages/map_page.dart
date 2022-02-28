import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../widgets/map_widget.dart';

class MapPage extends StatefulWidget {
  static const routeName = '/mappage';
  /*
    デフォルトでは、全てのトイレのリストをマップ上に表示
  */
  MapPage({Key? key, required this.filters}) : super(key: key);

  final Map<String, Object> filters;
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  LocationData? _currentLocation;
  StreamSubscription? _locationChangedListen;
  final Location _locationService = Location();
  final Completer<GoogleMapController> _controller = Completer();
  Map<String, Object> filters = {
    'multipurpose': false,
    'washlet': false,
    'madeyear': 1900,
    'recyclePaper': false,
    'singlePaper': false,
    'seatWarmer': false,
    'isfiltered': false,
  };

  // function to get the current location
  void _getLocation() async {
    _currentLocation = await _locationService.getLocation();
  }

  @override
  void initState() {
    filters['multipurpose'] = widget.filters['multipurpose'] as bool;
    filters['washlet'] = widget.filters['washlet'] as bool;
    filters['madeyear'] = widget.filters['madeyear'] as int;
    filters['recyclePaper'] = widget.filters['recyclePaper'] as bool;
    filters['singlePaper'] = widget.filters['singlePaper'] as bool;
    filters['seatWarmer'] = widget.filters['seatWarmer'] as bool;
    filters['isfiltered'] = widget.filters['isfiltered'] as bool;
    super.initState();

    // getting current location
    _getLocation();

    // supervising the change of location
    _locationChangedListen =
        _locationService.onLocationChanged.listen((LocationData result) async {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    // finish the supervising
    _locationChangedListen?.cancel();
  }

  Future<void> _goNOW() async {
    final GoogleMapController controller = await _controller.future;
    if (_currentLocation == null) {
      return;
    }
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          zoom: 18.7,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // search_pageからの引数をこっちの変数に代入している。
    // final routeArgs =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    // final washlet = routeArgs['washlet'];
    // final madeyear = routeArgs['madeyear'];
    // isfiltered = routeArgs['isfiltered'] as bool;

    return Scaffold(
      // isfilteredがtrueだとMapWidgetを呼び出し、falseだとMapWidget.anyを呼び出している。冗長。後で修正。
      body: !(filters['isfiltered'] as bool)
          ? _currentLocation == null
              ? MapWidget.any(
                  location: LocationData.fromMap({
                    'latitude': 35.712805509828605,
                    'longitude': 139.762034567044,
                  }),
                  mapController: _controller,
                )
              : MapWidget.any(
                  location: _currentLocation!,
                  mapController: _controller,
                )
          : _currentLocation == null
              ? MapWidget(
                  location: LocationData.fromMap({
                    'latitude': 35.712805509828605,
                    'longitude': 139.762034567044,
                  }),
                  mapController: _controller,
                  filters: filters,
                )
              : MapWidget(
                  location: _currentLocation!,
                  mapController: _controller,
                  filters: filters,
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goNOW,
        label: const Text(
          'Go NOW!!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
