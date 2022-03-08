import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../.env.dart';
import 'directions_model.dart';

class DirectionsRepository {
  // static variables
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  // constructor
  DirectionsRepository();

  // set some variables
  final Dio dio = Dio();

  // function to get direction from origin to destination
  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIKey,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
