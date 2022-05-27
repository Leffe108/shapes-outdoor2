import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

enum Shape {
  triangle,
  square,
  circle;

  String toUnicodeShape() {
    switch (name) {
      case 'triangle':
        return '▲';
      case 'square':
        return '■';
      case 'circle':
        return '●';
    }
    return '';
  }
}

class Poi {
  late Shape shape;
  late LatLng pos;

  Poi({required this.shape, required this.pos});
}

/// The shape distance in which the player has to be in
/// range to collect a shape
const collectRangeMeters = 50;

/// The duration that a player has to stay in range to collect
/// a shape.
const collectTime = Duration(seconds: 10);

class GameState extends ChangeNotifier {
  late List<Poi> _shapesToCollect;
  DateTime? _enterShape;
  LatLng? _playerPos;
  double? _distanceM;

  GameState() {
    clear();
  }

  void clear() {
    _shapesToCollect = [];
    _enterShape = null;
  }

  /// Create a new game
  void newGame(int n, LatLng center) {
    clear();

    List<Shape> shapes = [];
    shapes.addAll(Shape.values);
    shapes.shuffle();

    var bearing = -180.0;

    for (var i = 0; i < n; i++) {
      var pos = const Distance().offset(center, 500, bearing);
      _shapesToCollect.add(Poi(
        shape: shapes[i % shapes.length],
        pos: pos,
      ));

      bearing += 360 / n;
    }

    _shapesToCollect.shuffle();

    notifyListeners();
  }

  /// List of all shapes to collect
  List<Poi> get shapesToCollect => _shapesToCollect;

  /// Distance in meters to next shape
  double? get distanceMToNextShape => _distanceM;

  /// Non-null with the time when timer
  /// to collect a shape started. When
  /// time has eslapted to collectStartTime
  /// + collectTime duration, the shape
  /// will be collected. 
  DateTime? get collectStartTime => _enterShape;

  /// Get current player position
  LatLng? get playerPos => _playerPos;

  /// Is player currently in range of a shape?
  /// (awaiting for the collect time to be reached)
  bool get inRange => _enterShape != null;

  /// Set the current location of the player
  set playerPos(LatLng? pos) {
    var notify = _playerPos != pos;
    _playerPos = pos;

    if (_shapesToCollect.isNotEmpty) {
      var distToShape = const Distance().as(
        LengthUnit.Meter,
        _playerPos!,
        _shapesToCollect[0].pos,
      );
      if (distToShape != _distanceM) {
        _distanceM = distToShape;
        notify = true;
      }
      var inRange =
          _playerPos != null ? distToShape < collectRangeMeters : false;
      var now = DateTime.now();
      if (inRange &&
          _enterShape != null &&
          now.difference(_enterShape!) > collectTime) {
        // Stayed in range for at leat COLLECT_TIME => collect shape
        _shapesToCollect.removeAt(0);
        _enterShape = null;
        notify = true;
      } else if (inRange && _enterShape == null) {
        // Arrived in range => set enter time
        _enterShape = now;
        notify = true;
      } else if (!inRange && _enterShape != null) {
        // Went out of range => reset enter time
        _enterShape = null;
        notify = true;
      }
    }

    if (notify) notifyListeners();
  }
}
