import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/settings.dart';
import 'package:shapes_outdoor/utils/alert_dialog.dart';

/// Shows settings dialog
Future<void> showSettingsDialog(
  BuildContext context, {
  required bool inGame,
}) async {
  showAlert(
    context,
    const Text('Settings'),
    Builder(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<bool>(
                valueListenable: context.read<Settings>().backgroundLocation,
                builder: (context, value, child) {
                  return SwitchListTile(
                    title: const Text('Collect shapes in background'),
                    value: value,
                    onChanged: (newValue) async {
                      final setting =
                          context.read<Settings>().backgroundLocation;
                      if (newValue) {
                        if (!inGame) {
                          showAlert(
                            context,
                            const Text('Only in-game'),
                            const Text(
                                'You can only enable background location when you are in a game'),
                          );
                          return;
                        }
                        if (!await showYesNoDialog(
                          context,
                          const Text('Collect shapes in background?'),
                          ListView(
                            shrinkWrap: true,
                            children: const [
                              Text(
                                  'This optional feature allows completing shapes in the game while your phone is locked in your pocket. \n\n'
                                  'To collect shapes in the background, Shapes Outdoor needs access to your location even when the app is closed or not in use.'),
                              //  \n\nEnabling this will allow you to walk to a shape with the phone locked and sense a soft vibration when you walk in radius and then a stronger vibration when the shape has been collected.
                            ],
                          ),
                          yesButtonText: 'YES',
                          noButtonText: 'ABORT',
                        )) {
                          return;
                        }
                      }

                      setting.value = newValue;
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
    ),
    buttonText: 'CLOSE',
  );
}
