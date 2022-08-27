import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/router/resolve_route.dart';
import 'package:shapes_outdoor/widgets/stadium_button.dart';

class NewGameButton extends StatefulWidget {
  final Widget text;
  final GameLevel level;
  const NewGameButton(this.text, this.level, {Key? key}) : super(key: key);

  @override
  State<NewGameButton> createState() => _NewGameButtonState();
}

class _NewGameButtonState extends State<NewGameButton> {
  @override
  Widget build(BuildContext context) {
    return StadiumButton(
      text: widget.text,
      onPressed: () async {
        final router = Routemaster.of(context);
        final route = routeToStartLocation(widget.level);
        router.push(route);
      },
    );
  }
}
