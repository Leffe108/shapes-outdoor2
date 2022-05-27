
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/utils/locate.dart';

/// Watches current position and updates GameState.playerPos.
class LocationWatcher extends StatefulWidget {
  const LocationWatcher({Key? key}) : super(key: key);

  @override
  State<LocationWatcher> createState() => _LocationWatcherState();
}

class _LocationWatcherState extends State<LocationWatcher> {
  late Stream<LocationData> _stream;
  late StreamSubscription<LocationData> _streamSubscription;

  @override
  void initState() {
    _stream = watchPosition();
    _streamSubscription = _stream.listen((pos) { 
      print('new position: ${pos.latitude}, ${pos.longitude}');
      final state = Provider.of<GameState>(context, listen: false);
      if (pos.latitude != null && pos.longitude != null) {
        state.playerPos = LatLng(pos.latitude!, pos.longitude!);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}