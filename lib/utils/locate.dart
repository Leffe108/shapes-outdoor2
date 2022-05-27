
// ignore_for_file: unnecessary_this

import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

// Was not granted permission to location services
class PermissionError extends Exception {
  factory PermissionError(String message) {
    return PermissionError(message);
  }
}

// Location services is not on
class LocationServiceError extends Exception {
  factory LocationServiceError(String message) {
    return LocationServiceError(message);
  }
}

// An unknown error occured while receiving position
class LocationDataError extends Exception {
  factory LocationDataError(String message) {
    return LocationDataError(message);
  }
}

Future<LocationData> getUserPosition() async {
  final l = Location.instance;
  final status = await l.requestPermission();
  if (status != PermissionStatus.granted) {
    throw PermissionError(status.toString());
  }

  final service = await l.requestService();
  if (!service) {
    throw LocationServiceError('');
  }

  var pos = LocationData.fromMap({});
  try {
    pos = await l.getLocation();
  } catch (e) {
    throw LocationDataError('getLocation exception: $e');
  }
  if (pos.latitude != null && pos.longitude != null) {
    return pos;
  }

  throw LocationDataError('null lat/lon');
}

Stream<LocationData> watchPosition() {
  final l = Location.instance;
  return l.onLocationChanged;
}

extension LocationDataToLatLng on LocationData
{
  LatLng? toLatLng() {
    if (this.latitude != null && this.longitude != null) {
      return LatLng(latitude!, longitude!);
    }
    return null;
  }
}