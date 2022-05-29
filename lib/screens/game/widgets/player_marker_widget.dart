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
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.07)
                  : Colors.white.withOpacity(0.10),
              blurRadius: 5,
              spreadRadius: 5,
            ),
          ]),
      child: Icon(
        Icons.directions_walk,
        color: border,
        size: 22.0,
      ),
    );
  }
}
