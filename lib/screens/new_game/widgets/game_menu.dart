import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/new_game/widgets/new_game_button.dart';

import '../../../widgets/stadium_button.dart';

class GameMenu extends StatefulWidget {
  const GameMenu({Key? key}) : super(key: key);

  @override
  State<GameMenu> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  bool _showResume = false;

  @override
  void didChangeDependencies() {
    final state = Provider.of<GameState>(context, listen: true);
    final inProgress = state.gameDuration != null;
    if (inProgress && !_showResume) {
      (() async {
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        setState(() {
          _showResume = inProgress;
        });
      })();
    } else if (!inProgress && _showResume) {
      setState(() {
        _showResume = inProgress;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant GameMenu oldWidget) {
    final state = Provider.of<GameState>(context, listen: false);
    final inProgress = state.gameDuration != null;
    setState(() {
      _showResume = inProgress;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_showResume) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have a game in progress'),
          const SizedBox(
            height: 10,
          ),
          StadiumButton(
            text: const Text('Resume'),
            onPressed: () {
              Routemaster.of(context).push('/game');
            },
          ),
          const SizedBox(
            height: 10,
          ),
          StadiumButton(
            text: const Text('Abort'),
            primary: false,
            onPressed: () {
              final state = Provider.of<GameState>(context, listen: false);
              state.abort();
            },
          ),
        ],
      );
    }
    // Show game menu
    return Column(
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
    );
  }
}
