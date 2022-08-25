import 'package:flutter/material.dart';
import 'package:shapes_outdoor/screens/new_game/widgets/game_menu.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select level'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.all(50.0),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: const [
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
                            'shapes to collect are randomly positionated. If you find that a shape is unreachable or in a dangerous position, tap on it to skip.'),
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
