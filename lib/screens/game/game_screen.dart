
import 'package:flutter/material.dart';
import 'package:shapes_outdoor/screens/game/widgets/game_map.dart';
import 'package:shapes_outdoor/screens/game/widgets/game_status.dart';
import 'package:shapes_outdoor/screens/game/widgets/location_watcher.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collect shapes')),
      body: Column(children: const [
        Expanded(child: GameMap()),
        LocationWatcher(),
        GameStatus(),
      ]),
    );
  }
}