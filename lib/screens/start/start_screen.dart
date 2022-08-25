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
            GestureDetector(
              onTap: () {
                Routemaster.of(context).push('/new-game');
              },
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.10)
                            : Colors.black.withOpacity(0.15),
                        offset: const Offset(2, 2),
                        blurRadius: 5,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset('assets/start-image.jpg'),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
