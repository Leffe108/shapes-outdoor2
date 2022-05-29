import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/utils/settings_dialog.dart';
import 'package:shapes_outdoor/widgets/stadium_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50.0),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Column(children: [
            Text(
              'Shapes Outdoor',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Expanded(child: Container()),
            const SizedBox(height: 30),
            const AspectRatio(aspectRatio: 4 / 3, child: Placeholder()),
            const SizedBox(height: 10),
            const Text(
                'Collect shapes in your neigbourhood to complete this game.'),
            const SizedBox(height: 20),
            Expanded(child: Container()),
            StadiumButton(
              text: const Text('Start game'),
              onPressed: () {
                Routemaster.of(context).push('/new-game');
              },
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                showSettingsDialog(context);
              },
            ),
          ]),
        ),
      ),
    );
  }
}
