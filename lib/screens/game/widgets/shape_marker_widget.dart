import 'package:flutter/material.dart';
import 'package:shapes_outdoor/models/game_state.dart';

class ShapeMarkerWidget extends StatelessWidget {
  final Shape shape;

  const ShapeMarkerWidget(this.shape, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.secondary;
    return Center(
      child: Text(shape.toUnicodeShape(), style: TextStyle(color: color, fontSize: 20),),
    );
  }
}
