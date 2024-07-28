import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/models/settings.dart';
import 'package:shapes_outdoor/utils/locate.dart';

/// Watches current position and updates GameState.playerPos.
///
/// Also listens to background location setting and forwards
/// this to location plugin.
///
/// In background mode, this widget also updates the sticky
/// notification in android to show the next shape to collect.
class LocationWatcher extends StatefulWidget {
  const LocationWatcher({Key? key}) : super(key: key);

  @override
  State<LocationWatcher> createState() => _LocationWatcherState();
}

class _LocationWatcherState extends State<LocationWatcher> {
  late Stream<LocationData> _stream;
  late StreamSubscription<LocationData> _streamSubscription;
  late Settings _settings;
  late bool _background;
  ShapeType? _lastNextShape;

  @override
  void initState() {
    super.initState();
    _settings = Provider.of<Settings>(context, listen: false);
    _background = _settings.backgroundLocation.value;

    // Listen to backgroundLocation setting to turn on/off
    // background mode in the lifetime of the LocationWatcher.
    _settings.backgroundLocation.addListener(_restartStream);

    _startStream();
  }

  _startStream() {
    final location = Location();
    location.enableBackgroundMode(enable: _background);
    _stream = location.onLocationChanged;
    _streamSubscription = _stream.listen(
      (location) {
        final pos = location.toLatLng();
        if (pos != null) {
          final state = Provider.of<GameState>(context, listen: false);
          state.playerPos = pos;
        }
      },
      onDone: () => _stop(),
      onError: (Object error) => _stop(),
    );
  }

  /// Restart listening to locations with current _background state
  _restartStream() {
    _streamSubscription.cancel();
    _startStream();
  }

  /// Stop all listeners (so stream may not be re-started by an event)
  _stop() {
    _streamSubscription.cancel();
    _settings.backgroundLocation.removeListener(_restartStream);
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final nextShape = Provider.of<GameState>(context, listen: true).nextShape;
    if (nextShape != _lastNextShape) {
      final iconName = nextShape != null
          ? 'notification_${nextShape.toString().split('.').last}'
          : 'triangle';

      Location().changeNotificationOptions(
        title: 'Collect shapes in background',
        subtitle: 'Go to settings in Shapes Outdoor to disable.',
        color: Theme.of(context).colorScheme.primary,
        iconName: iconName,
        //onTapBringToFront: true,
      );

      setState(() {
        _lastNextShape = nextShape;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
