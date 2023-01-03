import 'package:flutter/foundation.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

/// Utility model that holds reference to the app setting
/// regarding if vibration should be enabled or not.
class Vibration {
  late final ValueNotifier<bool> setting;

  Vibration({required this.setting});

  /// Trigger a vibration if setting is enabled and the
  /// device supports vibration
  void vibrate(FeedbackType type) async {
    if (setting.value && await Vibrate.canVibrate) {
      Vibrate.feedback(type);
    }
  }
}
