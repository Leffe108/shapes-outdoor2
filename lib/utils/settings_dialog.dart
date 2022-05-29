import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/settings.dart';
import 'package:shapes_outdoor/utils/alert_dialog.dart';

/// Shows a dialog with yes/no buttons. Resolves to true if
/// user press Yes button, otherwise false.
Future<void> showSettingsDialog(BuildContext context) async {
  showAlert(context, const Text('Settings'), Builder(
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<bool>(
              valueListenable: context.read<Settings>().backgroundLocation,
              builder: (context, value, child) {
                return SwitchListTile(
                  title: const Text('Use location in background'),
                  value: value,
                  onChanged: (newValue) {
                    context.read<Settings>().backgroundLocation.value =
                        newValue;
                  },
                );
              }),
          ValueListenableBuilder<bool>(
              valueListenable: context.read<Settings>().vibrate,
              builder: (context, value, child) {
                return SwitchListTile(
                  title: const Text('Vibrate'),
                  value: value,
                  onChanged: (newValue) {
                    context.read<Settings>().vibrate.value = newValue;
                  },
                );
              }),
        ],
      );
    },
  ));
}
