import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/game/widgets/game_map.dart';
import 'package:shapes_outdoor/screens/game/widgets/game_status.dart';
import 'package:shapes_outdoor/screens/game/widgets/location_watcher.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Builder(builder: (context) {
          final nextShape = context.select<GameState, ShapeType?>(
            (state) => state.nextShape,
          );
          final s = nextShape != null
              ? 'Go to a ${nextShape.toString().split('.').last}'
              : 'Collect shapes';
          return Text(s);
        }),
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
