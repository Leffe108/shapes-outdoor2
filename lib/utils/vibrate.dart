import 'package:flutter/services.dart';

void vibrate() async {
  HapticFeedback.mediumImpact();
}