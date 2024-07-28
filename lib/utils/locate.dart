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
  if (pos.latitude != null && pos.longitude != null) {
    return pos;
  }

  throw LocationDataError('null lat/lon');
}

extension LocationDataToLatLng on LocationData {
  LatLng? toLatLng() {
    if (this.latitude != null && this.longitude != null) {
      return LatLng(latitude!, longitude!);
    }
    return null;
  }
}

bool isGranted(PermissionStatus? value) {
  return [PermissionStatus.granted, PermissionStatus.grantedLimited]
      .contains(value);
}
