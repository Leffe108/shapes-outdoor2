import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/game_state.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
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
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Collect: '),
              Expanded(
                child: Consumer<GameState>(
                  builder: ((context, state, child) {
                    return Wrap(
                      children: [
                        for (var poi in state.shapesToCollect) Text('${poi.shape.toString().split('.')[1]}, '),
                      ],
                    );
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
