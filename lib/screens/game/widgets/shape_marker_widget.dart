import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';

class ShapeMarkerWidget extends StatelessWidget {
  final int index;
  final double size;

  /// index in GameState.shapesToCollect

  const ShapeMarkerWidget(this.index, this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<GameState>(
      builder: (context, state, child) {
        final nextShape = state.shapesToCollect[0].shape;
        final shape = state.shapesToCollect[index].shape;
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Out of reach?'),
                        content: const Text(
                            'If a shape is not reachable, you can skip it.\n\nShould this shape be skipped?'),
                        actions: [
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              final state = Provider.of<GameState>(context,
                                  listen: false);
                              state.skip(index);
                              Routemaster.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Routemaster.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
