import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/utils/alert_dialog.dart';
import 'package:shapes_outdoor/utils/locate.dart';

class NewGameButton extends StatefulWidget {
  final Widget label;
  final int n;
  const NewGameButton(this.label, this.n, {Key? key}) : super(key: key);

  @override
  State<NewGameButton> createState() => _NewGameButtonState();
}

class _NewGameButtonState extends State<NewGameButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(const StadiumBorder()),
        visualDensity: VisualDensity.comfortable,
        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16)),
      ),
      onPressed: () async {
        var state = Provider.of<GameState>(context, listen: false);

        LatLng? pos;
        try {
          pos = await getUserPosition();
        } catch (e) {
          if (!mounted) return;
          if (e is PermissionError) {
            showAlert(
                context,
                const Text('No access'),
                const Text(
                    'You need to grant access to location services to play this game.'));
            return;
          } else if (e is LocationServiceError) {
            showAlert(
                context,
                const Text('Location services is off'),
                const Text(
                    'You need to turn on location services to play this game.'));
            return;
          } else {
            showAlert(
                context,
                const Text('Location error'),
                Text(
                    'An error occured wile obtaining your position: $e'));
            return;
          }
        }

        state.newGame(widget.n, pos);
        state.playerPos = pos;
        if (!mounted) return;
        Routemaster.of(context).push('/game');
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: widget.label,
      ),
    );
  }
}
