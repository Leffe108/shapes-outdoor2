import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/game_state.dart';

class PlayerMarkerWidget extends StatelessWidget {
  const PlayerMarkerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.colorScheme.secondary;
    final bg = Color.lerp(border, Colors.white, 0.7);
    //return Center(child: Icon(Icons.directions_walk, color: border, size: 12.0,));
    return Consumer<GameState>(builder: (context, state, child) {
      return Transform.rotate(
        angle: (state.playerHeading ?? 0.0) / 180 * pi,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10000),
                topRight: Radius.circular(10000)),
          ),
          child: Icon(
            Icons.directions_walk,
            color: border,
            size: 12.0,
          ),
        ),
      );
    });
  }
}
