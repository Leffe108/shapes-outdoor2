import 'package:flutter/material.dart';

class PlayerMarkerWidget extends StatelessWidget {
  const PlayerMarkerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.colorScheme.secondary;
    final bg = Color.lerp(border, Colors.white, 0.7);
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(10000)),
      ),
      child: Icon(
        Icons.directions_walk,
        color: border,
        size: 22.0,
      ),
    );
  }
}
