import 'dart:async';

import 'package:location/location.dart';

class LocationManager {
  bool? _background;
  late Stream<LocationData> _stream;
  late StreamSubscription<LocationData> _streamSubscription;
}
