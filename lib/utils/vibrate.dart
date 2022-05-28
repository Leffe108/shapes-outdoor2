import 'package:flutter_vibrate/flutter_vibrate.dart';

void vibrate(FeedbackType type) async {
  if (await Vibrate.canVibrate) {
    Vibrate.feedback(type);
  }
}