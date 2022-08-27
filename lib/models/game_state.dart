import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:latlong2/latlong.dart';
import 'package:shapes_outdoor/utils/vibrate.dart';

enum GameLevel {
  mini,
  neardy,
  medium,
  sprawl,
}

enum ShapeType {
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
        return '⬤';
    }
    return '';
  }
}

class ShapePoint {
  late ShapeType shape;
  late LatLng pos;

  ShapePoint({required this.shape, required this.pos});
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

  /// Shape collect order
  late List<ShapeType> _shapes;

  /// List of points that each has a ShapeType
  late List<ShapePoint> _points;

  /// When did player reach in range of closest point?
  DateTime? _enterPoint;
  LatLng? _playerPos;
  _ClosestPointDist? _closestPoint;

  GameState() {
    _clear();
  }

  void _clear() {
    _gameStart = null;
    _gameEnd = null;
    _points = [];
    _shapes = [];
    _enterPoint = null;
    _playerPos = null;
    _closestPoint = null;
  }

  /// Abort current game
  void abort() {
    _clear();
    notifyListeners();
  }

  void newGameFromLevel(LatLng center, GameLevel level) {
    switch (level) {
      case GameLevel.mini:
        newGame(center, 2, 150, 150);
        break;
      case GameLevel.neardy:
        newGame(center, 5, 200, 200);
        break;
      case GameLevel.medium:
        newGame(center, 9, 250, 750);
        break;
      case GameLevel.sprawl:
        newGame(center, 9, 250, 2500);
        break;
      default:
        throw Exception('Unknown level');
    }
  }

  /// Create a new game
  /// @param center The center location to generate from
  /// @param n Number of shapes to create
  /// @param minRangeM mimimum range from center in meters
  /// @param minRangeM maximum range from center in meters
  void newGame(LatLng center, int n, int minRangeM, int maxRangeM) {
    _clear();

    _gameStart = DateTime.now();

    List<ShapeType> shapes = [];
    shapes.addAll(ShapeType.values);
    // Shuffle the order of shapes in points
    shapes.shuffle();

    var bearing = Random().nextDouble() * 360.0 - 180.0;

    for (var i = 0; i < n; i++) {
      final range = minRangeM +
          ((maxRangeM - minRangeM) > 0
              ? Random().nextInt(maxRangeM - minRangeM)
              : 0);
      final pos = const Distance().offset(center, range, bearing);
      final shape = shapes[i % shapes.length];
      _points.add(ShapePoint(
        shape: shapes[i % shapes.length],
        pos: pos,
      ));
      _shapes.add(shape);

      bearing += 360 / n;
    }

    // Shuffle collect order
    _shapes.shuffle();

    notifyListeners();
  }

  /// List of all points to collect
  List<ShapePoint> get points => _points;

  /// List giving ShapeType to collect order
  List<ShapeType> get shapesToCollect => _shapes;

  /// Next shape to collect
  ShapeType? get nextShape => _shapes.isNotEmpty ? _shapes[0] : null;

  /// Distance in meters to next shape
  double? get closestShapeDistanceM => _closestPoint?.distM;

  /// Index in shapesToCollect to the closest
  /// point of desired ShapeType
  int? get closestShapeIndex => _closestPoint?.index;

  /// Non-null with the time when timer
  /// to collect a shape started. When
  /// time has eslapted to collectStartTime
  /// + collectTime duration, the shape
  /// will be collected.
  DateTime? get collectStartTime => _enterPoint;

  /// Get current player position
  LatLng? get playerPos => _playerPos;

  /// Is player currently in range of a shape?
  /// (awaiting for the collect time to be reached)
  bool get inRange => _enterPoint != null;

  Duration? get gameDuration => _gameStart == null
      ? null
      : (_gameEnd == null
          ? DateTime.now().difference(_gameStart!)
          : _gameEnd!.difference(_gameStart!));

  /// Set the current location of the player
  set playerPos(LatLng? pos) {
    var notify = _playerPos != pos;
    _playerPos = pos;

    if (_points.isNotEmpty) {
      final closestPoint = _findClosestPoint(_playerPos!, _shapes[0]);
      assert(closestPoint.index != -1);
      if (_closestPoint == null ||
          closestPoint.distM != _closestPoint!.distM ||
          closestPoint.index != _closestPoint!.index) {
        _closestPoint = closestPoint;
        notify = true;
      }
      var inRange =
          _playerPos != null ? closestPoint.distM < collectRangeMeters : false;
      var now = DateTime.now();
      if (inRange &&
          _enterPoint != null &&
          now.difference(_enterPoint!) > collectTime) {
        // Stayed in range for at leat COLLECT_TIME => collect shape
        _collectIndex(closestPoint.index);
        notify = true;
      } else if (inRange && _enterPoint == null) {
        // Arrived in range => set enter time
        _enterPoint = now;
        vibrate(FeedbackType.medium);
        notify = true;
      } else if (!inRange && _enterPoint != null) {
        // Went out of range => reset enter time
        _enterPoint = null;
        vibrate(FeedbackType.light);
        notify = true;
      }
    }

    if (notify) notifyListeners();
  }

  /// Skip a point
  void skip(int index) {
    _collectIndex(index);
    notifyListeners();
  }

  /// Collect the point at given index in _points
  void _collectIndex(int index) {
    _shapes.remove(_points[index].shape);
    _points.removeAt(index);
    _enterPoint = null;
    _closestPoint = null;
    if (_points.isEmpty) {
      _gameEnd = DateTime.now();
    }

    vibrate(FeedbackType.heavy);
  }

  /// Get the closest point of give shape
  /// @return -1 or index in _points
  _ClosestPointDist _findClosestPoint(LatLng pos, ShapeType shape) {
    const d = Distance();
    var minDist = double.maxFinite;
    int closestIndex = -1;

    for (var i = 0; i < _points.length; i++) {
      final point = _points[i];
      if (point.shape == shape) {
        final dist = d.as(LengthUnit.Meter, pos, point.pos);
        if (dist < minDist) {
          minDist = dist;
          closestIndex = i;
        }
      }
    }

    return _ClosestPointDist(closestIndex, minDist);
  }
}

class _ClosestPointDist {
  late int index;
  late double distM;

  _ClosestPointDist(this.index, this.distM);
}
