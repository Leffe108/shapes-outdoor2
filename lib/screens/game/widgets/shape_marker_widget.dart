import 'package:flutter/material.dart';
import 'package:shapes_outdoor/models/game_state.dart';

class ShapeMarkerWidget extends StatelessWidget {
  final Shape shape;

  const ShapeMarkerWidget(this.shape, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(shape.toUnicodeShape(), style: const TextStyle(color: Colors.red, fontSize: 20),),
    );
  }
}
