import 'package:flutter/foundation.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

/// Utility model that holds reference to the app setting
/// regarding if vibration should be enabled or not.
class Vibration {
  late final ValueNotifier<bool> setting;

  Vibration({required this.setting});

  /// Trigger a vibration if setting is enabled and the
  /// device supports vibration
  void vibrate(HapticsType type) async {
    if (setting.value && await Haptics.canVibrate()) {
      Haptics.vibrate(type);
    }
  }
}
