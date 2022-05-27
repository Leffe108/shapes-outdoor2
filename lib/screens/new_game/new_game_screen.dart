import 'package:flutter/material.dart';
import 'package:shapes_outdoor/screens/new_game/widgets/new_game_button.dart';

class NewGameScreen extends StatelessWidget {
  const NewGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New game')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            NewGameButton(Text('Easy game'), 5),
            SizedBox(height: 20,),
            NewGameButton(Text('Hard game'), 15),
          ],
        ),
      ),
    );
  }
}
