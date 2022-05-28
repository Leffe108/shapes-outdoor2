import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/widgets/stadium_button.dart';
import 'package:shapes_outdoor/utils/alert_dialog.dart';
import 'package:shapes_outdoor/utils/locate.dart';

class NewGameButton extends StatefulWidget {
  final Widget text;
  final int n;
  final int minRangeM;
  final int maxRangeM;
  const NewGameButton(this.text, this.n, this.minRangeM, this.maxRangeM,
      {Key? key})
      : super(key: key);

  @override
  State<NewGameButton> createState() => _NewGameButtonState();
}

class _NewGameButtonState extends State<NewGameButton> {
  @override
  Widget build(BuildContext context) {
    return StadiumButton(
      text: widget.text,
      onPressed: () async {
        var state = Provider.of<GameState>(context, listen: false);

        LocationData? location;
        LatLng? pos;
        try {
          location = await getUserPosition();
          pos = location.toLatLng();
          if (pos == null) throw LocationDataError('');
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
            showAlert(context, const Text('Location error'),
                Text('An error occured wile obtaining your position: $e'));
            return;
          }
        }

        state.newGame(pos, widget.n, widget.minRangeM, widget.maxRangeM);
        state.setPlayerPos(pos, location.heading);
        if (!mounted) return;
        Routemaster.of(context).push('/game');
      },
    );
  }
}
