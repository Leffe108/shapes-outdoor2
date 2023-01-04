import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/game/widgets/game_map.dart';
import 'package:shapes_outdoor/screens/game/widgets/game_status.dart';
import 'package:shapes_outdoor/screens/game/widgets/location_watcher.dart';
import 'package:shapes_outdoor/utils/settings_dialog.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const titleKey = Key('GAME_TITLE');
  static const closeKey = Key('GAME_CLOSE');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Routemaster.of(context).pop();
          },
          key: closeKey,
        ),
        title: Builder(builder: (context) {
          final nextShape = context.select<GameState, ShapeType?>(
            (state) => state.nextShape,
          );
          final s = nextShape != null
              ? 'Go to a ${nextShape.toString().split('.').last}'
              : 'Collect shapes';
          return Text(s, key: titleKey);
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showSettingsDialog(context, inGame: true);
            },
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(children: const [
        Expanded(child: GameMap()),
        LocationWatcher(),
        GameStatus(),
      ]),
    );
  }
}
