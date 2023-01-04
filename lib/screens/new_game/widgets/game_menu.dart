import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/new_game/widgets/new_game_button.dart';

import '../../../widgets/stadium_button.dart';

class GameMenu extends StatefulWidget {
  const GameMenu({Key? key}) : super(key: key);

  static const miniKey = Key('NEW_GAME_MINI');
  static const abortGameKey = Key('NEW_GAME_ABORT_GAME');
  static const resumeGameKey = Key('NEW_GAME_RESUME_GAME');

  @override
  State<GameMenu> createState() => _GameMenuState();
}

class _GameMenuState extends State<GameMenu> {
  bool _showResume = false;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    updateShowResume();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant GameMenu oldWidget) {
    updateShowResume();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void updateShowResume() {
    final state = Provider.of<GameState>(context, listen: true);
    final inProgress = state.gameDuration != null;
    if (inProgress && !_showResume) {
      _timer = Timer(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _showResume = inProgress;
          _timer = null;
        });
      });
    } else if (!inProgress && _showResume) {
      setState(() {
        _showResume = inProgress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showResume) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have a game in progress'),
          const SizedBox(
            height: 30,
          ),
          StadiumButton(
            text: const Text('Resume'),
            onPressed: () {
              Routemaster.of(context).push('/new-game/game');
            },
            key: GameMenu.resumeGameKey,
          ),
          const SizedBox(
            height: 50,
          ),
          StadiumButton(
            text: const Text('Abort'),
            primary: false,
            color: Colors.deepOrange,
            onPressed: () {
              final state = Provider.of<GameState>(context, listen: false);
              state.abort();
            },
            key: GameMenu.abortGameKey,
          ),
        ],
      );
    }
    // Show game menu
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        NewGameButton(Text('Mini'), GameLevel.mini, key: GameMenu.miniKey),
        SizedBox(
          height: 20,
        ),
        NewGameButton(Text('Nearby'), GameLevel.neardy),
        SizedBox(
          height: 20,
        ),
        NewGameButton(Text(' Medium '), GameLevel.medium),
        SizedBox(
          height: 20,
        ),
        NewGameButton(Text('         Sprawl         '), GameLevel.sprawl),
      ],
    );
  }
}
