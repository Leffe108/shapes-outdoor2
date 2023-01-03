import 'package:flutter_test/flutter_test.dart';
import 'package:shapes_outdoor/utils/format.dart';

void main() {
  test('humanDuration', () {
    expect(humanDuration(const Duration(seconds: 5)), '5s');
    expect(humanDuration(const Duration(seconds: 25)), '25s');
    expect(humanDuration(const Duration(seconds: 60)), '1min 0s');
    expect(humanDuration(const Duration(seconds: 70)), '1min 10s');
    expect(humanDuration(const Duration(hours: 2)), '2h 0min 0s');
    expect(humanDuration(const Duration(hours: 2, minutes: 5)), '2h 5min 0s');
    expect(
      humanDuration(const Duration(hours: 2, minutes: 5, seconds: 7)),
      '2h 5min 7s',
    );
    expect(humanDuration(const Duration(hours: 2, seconds: 7)), '2h 0min 7s');
    expect(humanDuration(const Duration(days: 1)), '1 day 0h 0min 0s');
    expect(humanDuration(const Duration(days: 2)), '2 days 0h 0min 0s');
  });
}
