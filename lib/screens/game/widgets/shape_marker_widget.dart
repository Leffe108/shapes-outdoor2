import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/utils/alert_dialog.dart';

class ShapeMarkerWidget extends StatelessWidget {
  /// index in GameState.points
  final int index;
  final double size;

  const ShapeMarkerWidget(this.index, this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<GameState>(
      builder: (context, state, child) {
        final nextShape = state.shapesToCollect[0];
        final shape = state.points[index].shape;
        final closest = state.closestShapeIndex == index;
        final inRange =
            closest && state.closestShapeDistanceM! < collectRangeMeters;
        final color = inRange
            ? theme.colorScheme.primary
            : (shape == nextShape
                ? theme.colorScheme.secondary
                : Colors.grey[600]!);

        final textWidget = Text(
          shape.toUnicodeShape(),
          style: TextStyle(color: color, fontSize: 20),
        );

        return Center(
          key: ValueKey<Color>(color),
          // Only allow skipping a shape if it is a next shape.
          // To reduce risk of button overlap and skipping wrong
          // shape by accident.
          child: shape != nextShape
              ? textWidget
              : TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(size, size),
                    maximumSize: Size(size, size),
                    primary: color,
                    shape: const CircleBorder(),
                  ),
                  child: textWidget,
                  onPressed: () async {
                    final skip = await showYesNoDialog(
                        context,
                        Text('Out of reach?'),
                        Text(
                            'If a shape is not reachable, you can skip it.\n\nShould this shape be skipped?'));
                    if (skip) {
                      final state =
                          Provider.of<GameState>(context, listen: false);
                      state.skip(index);
                    }
                  },
                ),
        );
      },
    );
  }
}
