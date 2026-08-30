// ignore_for_file: unnecessary_this

import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

// Was not granted permission to location services
class PermissionError extends Exception {
  factory PermissionError(String message) {
    return PermissionError(message);
  }
}

// An unknown error occured while receiving position
class LocationDataError extends Exception {
  factory LocationDataError(String message) {
    return LocationDataError(message);
  }
}

Future<LocationData> getUserPosition() async {
  final location = Location();
  final status = await location.requestPermission();
  if (!isGranted(status)) {
    throw PermissionError(status.toString());
  }

  late LocationData pos;
  try {
    pos = await location.getLocation();
  } catch (e) {
    throw LocationDataError('getLocation exception: $e');
  }
  return pos;
}

extension LocationDataToLatLng on LocationData {
  LatLng? toLatLng() {
    return LatLng(latitude, longitude);
  }
}

bool isGranted(PermissionStatus? value) {
  return [PermissionStatus.granted, PermissionStatus.grantedLimited]
      .contains(value);
}
