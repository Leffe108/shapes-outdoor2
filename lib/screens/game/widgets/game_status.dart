import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/game/widgets/collect_progress_indicator.dart';
import 'package:shapes_outdoor/utils/format.dart';
import 'package:shapes_outdoor/widgets/stadium_button.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 20,
            spreadRadius: 20,
            color: Color.fromARGB(30, 0, 0, 0),
          ),
          BoxShadow(
            blurRadius: 3,
            spreadRadius: 3,
            color: Color.fromARGB(50, 0, 0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      child: Consumer<GameState>(
        builder: (context, state, child) {
          final endOfGame = state.shapesToCollect.isEmpty;
          final collectStr = state.shapesToCollect
              .map((shape) => shape.toUnicodeShape())
              .toList()
              .join(', ');
          return Column(
            children: [
              const CollectProgressIndicator(key: Key('collect-progress')),
              if (!endOfGame) ...[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Collect: '),
                    Expanded(
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                            text: collectStr.substring(0, 1),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                        TextSpan(text: collectStr.substring(1)),
                      ])),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Distance: '),
                    Expanded(
                      child: state.closestShapeDistanceM == null
                          ? const Text('-')
                          : Text('${state.closestShapeDistanceM!.round()} m'),
                    ),
                  ],
                ),
              ],
              if (endOfGame) ...[
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Victory!\n\nYou have collected all shapes${state.gameDuration != null ? ' in ${humanDuration(state.gameDuration!)}' : ''}.',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                StadiumButton(
                    text: const Text('End game'),
                    onPressed: () {
                      context.read<GameState>().abort();
                      Routemaster.of(context).pop();
                    }),
                const SizedBox(
                  height: 15,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
