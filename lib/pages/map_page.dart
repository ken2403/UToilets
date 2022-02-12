import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  LocationData? _currentLocation;
  StreamSubscription? _locationChangedListen;
  final Location _locationService = Location();
  final Completer<GoogleMapController> _controller = Completer();

  // function to get the current location
  void _getLocation() async {
    _currentLocation = await _locationService.getLocation();
  }

  @override
  void initState() {
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
    return Scaffold(
      body: _currentLocation == null
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
