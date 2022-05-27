import 'package:flutter/material.dart';

class GameMenuButton extends StatelessWidget {
  final Widget text;
  final void Function() onPressed;
  final bool primary;
  const GameMenuButton({
    required this.text,
    required this.onPressed,
    this.primary = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary:
            primary ? Theme.of(context).colorScheme.primary : Colors.deepOrange,
        shape: const StadiumBorder(),
        visualDensity: VisualDensity.comfortable,
        textStyle: TextStyle(fontSize: primary ? 16 : 12),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.all(primary ? 10.0 : 0.0),
        child: text,
      ),
    );
  }
}
