import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/models/vibration.dart';

void main() {
  test('GameState', () async {
    final vibrateSetting = ValueNotifier<bool>(false);
    final vibration = Vibration(setting: vibrateSetting);
    final state = GameState(vibration: vibration);
    state.newGameFromLevel(LatLng(0, 0), GameLevel.mini);
    expect(state.points.length, greaterThan(0));

    state.newGame(LatLng(0, 0), 3, 100, 100);
    expect(state.points.length, 3);
    expect(state.shapesToCollect.length, 3);
    state.playerPos = LatLng(0, 0);
    expect(state.closestShapeDistanceM, 100.0);
    expect(state.inRange, false);
    expect(state.nextShape, isNotNull);
    expect(state.collectStartTime, isNull);

    final goTo = state.points.firstWhere((sp) => sp.shape == state.nextShape);
    state.playerPos = goTo.pos;
    expect(state.inRange, true);
    expect(state.collectStartTime, isNotNull);

    state.mockCollectTimerCompleted();
    expect(state.inRange, false);
    expect(state.points.length, 2);
    expect(state.shapesToCollect.length, 2);

    state.skip(1);
    state.skip(0);
    expect(state.shapesToCollect.length, 0);
    expect(state.closestShapeDistanceM, isNull);
  });
}
