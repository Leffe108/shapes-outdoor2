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
  DateTime? _gameStart;
  DateTime? _gameEnd;
  late List<Poi> _shapesToCollect;

  /// When did player reach in range of closest poi?
  DateTime? _enterShape;
  LatLng? _playerPos;
  _ClosestPoiDist? _closestPoi;

  GameState() {
    clear();
  }

  void clear() {
    _gameStart = null;
    _gameEnd = null;
    _shapesToCollect = [];
    _enterShape = null;
  }

  /// Create a new game
  /// @param center The center location to generate from
  /// @param n Number of shapes to create
  /// @param minRangeM mimimum range from center in meters
  /// @param minRangeM maximum range from center in meters
  void newGame(LatLng center, int n, int minRangeM, int maxRangeM) {
    clear();

    _gameStart = DateTime.now();

    List<Shape> shapes = [];
    shapes.addAll(Shape.values);
    shapes.shuffle();

    var bearing = -180.0;

    for (var i = 0; i < n; i++) {
      final range = minRangeM +
          ((maxRangeM - minRangeM) > 0
              ? Random().nextInt(maxRangeM - minRangeM)
              : 0);
      var pos = const Distance().offset(center, range, bearing);
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
  double? get closestShapeDistanceM => _closestPoi?.distM;

  /// Index in shapesToCollect to the closest
  /// POI of desired shape
  int? get closestShapeIndex => _closestPoi?.index;

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

  Duration? get gameDuration => _gameStart == null
      ? null
      : (_gameEnd == null
          ? DateTime.now().difference(_gameStart!)
          : _gameEnd!.difference(_gameStart!));

  /// Set the current location of the player
  set playerPos(LatLng? pos) {
    var notify = _playerPos != pos;
    _playerPos = pos;

    if (_shapesToCollect.isNotEmpty) {
      final closestPoi =
          _closestShapeIndex(_playerPos!, _shapesToCollect[0].shape);
      assert(closestPoi.index != -1);
      if (_closestPoi == null ||
          closestPoi.distM != _closestPoi!.distM ||
          closestPoi.index != _closestPoi!.index) {
        _closestPoi = closestPoi;
        notify = true;
      }
      var inRange =
          _playerPos != null ? closestPoi.distM < collectRangeMeters : false;
      var now = DateTime.now();
      if (inRange &&
          _enterShape != null &&
          now.difference(_enterShape!) > collectTime) {
        // Stayed in range for at leat COLLECT_TIME => collect shape
        _collectIndex(closestPoi.index);
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

  /// Skip a shape - removes it from shapesToCollect
  void skip(int index) {
    _collectIndex(index);
    notifyListeners();
  }

  /// Collect the shape at given index
  void _collectIndex(int index) {
    _shapesToCollect.removeAt(index);
    _enterShape = null;
    _closestPoi = null;
    if (_shapesToCollect.isEmpty) {
      _gameEnd = DateTime.now();
    }
  }

  /// Get the closest poi of give shape
  /// @return -1 or index in _shapesToCollect
  _ClosestPoiDist _closestShapeIndex(LatLng pos, Shape shape) {
    const d = Distance();
    var minDist = double.maxFinite;
    int closestIndex = -1;

    for (var i = 0; i < _shapesToCollect.length; i++) {
      final poi = _shapesToCollect[i];
      if (poi.shape == shape) {
        final dist = d.as(LengthUnit.Meter, pos, poi.pos);
        if (dist < minDist) {
          minDist = dist;
          closestIndex = i;
        }
      }
    }

    return _ClosestPoiDist(closestIndex, minDist);
  }
}

class _ClosestPoiDist {
  late int index;
  late double distM;

  _ClosestPoiDist(this.index, this.distM);
}
