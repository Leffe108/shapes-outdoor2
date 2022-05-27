import 'package:flutter/material.dart';
import 'package:shapes_outdoor/screens/new_game/widgets/new_game_button.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shapes Outdoor'), centerTitle: true,),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Collect shapes in your neigbourhood to complete this game.'),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      NewGameButton(Text('Mini'), 2, 150, 150),
                      SizedBox(
                        height: 20,
                      ),
                      NewGameButton(Text('Nearby'), 5, 200, 200),
                      SizedBox(
                        height: 20,
                      ),
                      NewGameButton(Text(' Medium '), 9, 250, 750),
                      SizedBox(
                        height: 20,
                      ),
                      NewGameButton(Text('         Sprawl         '), 9, 250, 2500),
                    ],
                  ),
                ),
                const Text.rich(TextSpan(
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
