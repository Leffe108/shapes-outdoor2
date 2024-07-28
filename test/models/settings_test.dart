import 'package:flutter_test/flutter_test.dart';
import 'package:shapes_outdoor/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Settings', () async {
    // Wipe shared preferences before test
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    final model = Settings();
    await pumpEventQueue();

    // Default values
    expect(model.vibrate.value, true);
    expect(model.backgroundLocation.value, false);

    // Can change
    model.vibrate.value = false;
    expect(model.vibrate.value, false);
    model.backgroundLocation.value = true;
    expect(model.backgroundLocation.value, true);
    await pumpEventQueue();

    // Is persisted
    final model2 = Settings();
    await pumpEventQueue();
    expect(model2.vibrate.value, false);
    expect(model2.backgroundLocation.value, true);
  });
}
