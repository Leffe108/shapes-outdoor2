import 'package:flutter/material.dart';

class StadiumButton extends StatelessWidget {
  final Widget text;
  final void Function() onPressed;
  final bool primary;
  final Color? color;
  const StadiumButton({
    required this.text,
    required this.onPressed,
    this.primary = true,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color ?? Theme.of(context).colorScheme.primary,
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
