import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/game/widgets/collect_progress_indicator.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
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
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const CollectProgressIndicator(),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Collect: '),
              Expanded(
                child: Consumer<GameState>(
                  builder: ((context, state, child) {
                    return Text(state.shapesToCollect
                        .map((poi) => poi.shape.toString().split('.')[1])
                        .toList()
                        .join(', '));
                  }),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Distance: '),
              Expanded(
                child: Consumer<GameState>(
                  builder: ((context, state, child) {
                    if (state.distanceMToNextShape == null) {
                      return const Text('-');
                    }
                    return Text('${state.distanceMToNextShape!.round()} m');
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
