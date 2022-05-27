import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/new_game/widgets/game_menu.dart';
import 'package:shapes_outdoor/screens/new_game/widgets/new_game_button.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shapes Outdoor'),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: const [
                Text(
                    'Collect shapes in your neigbourhood to complete this game.'),
                Expanded(
                  child: GameMenu(),
                ),
                Text.rich(TextSpan(
                  children: [
                    TextSpan(
                        text: 'Note: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'shapes to collect are randomly positionated. If you find in the game that a shape is unreachable or in a dangerous position, tap on it to skip.'),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
