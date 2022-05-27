import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/game_state.dart';

class ShapeMarkerWidget extends StatelessWidget {
  final int index; /// index in GameState.shapesToCollect

  const ShapeMarkerWidget(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<GameState>(
      builder: (context, state, child) {
        final shape = state.shapesToCollect[index].shape;
        final closest = state.closestShapeIndex == index;
        final inRange = closest && state.closestShapeDistanceM! < collectRangeMeters;
        final color =  inRange ? theme.colorScheme.primary : theme.colorScheme.secondary;
        return Center(
          key: ValueKey<Color>(color),
          child: Text(shape.toUnicodeShape(), style: TextStyle(color: color, fontSize: 20),),
        );
      }
    );
  }
}
