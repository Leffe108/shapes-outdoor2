import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  ValueNotifier<bool> backgroundLocation = ValueNotifier<bool>(false);
  ValueNotifier<bool> vibrate = ValueNotifier<bool>(true);

  Settings() {
    _load();

    backgroundLocation.addListener(() async {
      final store = await SharedPreferences.getInstance();
      store.setBool(_bglocKey, backgroundLocation.value);
    });
    vibrate.addListener(() async {
      final store = await SharedPreferences.getInstance();
      store.setBool(_vibrateKey, vibrate.value);
    });
  }

  Future<void> _load() async {
    final store = await SharedPreferences.getInstance();
    backgroundLocation.value =
        store.getBool(_bglocKey) ?? backgroundLocation.value;
    vibrate.value = store.getBool(_vibrateKey) ?? vibrate.value;
  }
}

const _bglocKey = 'bgLoc';
const _vibrateKey = 'vibrate';
