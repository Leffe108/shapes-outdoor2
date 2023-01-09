import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/utils/alert_dialog.dart';
import 'package:shapes_outdoor/utils/locate.dart';
import 'package:shapes_outdoor/utils/privacy_policy.dart';
import 'package:shapes_outdoor/widgets/stadium_button.dart';

/// Screen responsible for obtaining permission to access location
/// and for obtaining the start location of a new game.
/// When location has been obtained, it starts the game in GameState
/// and navigates to GameScreen.
class StartLocationScreen extends StatefulWidget {
  final GameLevel level;
  const StartLocationScreen(this.level, {Key? key}) : super(key: key);

  static const locationAccessTitleKey = Key('START_LOCATION_ACCESS_TITLE');
  static const findPositionTitleKey = Key('START_LOCATION_FIND_TITLE');

  @override
  State<StartLocationScreen> createState() => _StartLocationScreenState();
}

class _StartLocationScreenState extends State<StartLocationScreen> {
  PermissionStatus? permissionStatus;

  @override
  void didChangeDependencies() {
    if (permissionStatus == null) {
      getPermissionStatus().then((value) {
        setState(() => permissionStatus = value);

        if (isGranted(value)) {
          locatePlayerAndStartGame();
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isGranted(permissionStatus)
              ? 'Finding your location'
              : 'Location accesss',
          key: isGranted(permissionStatus)
              ? StartLocationScreen.findPositionTitleKey
              : StartLocationScreen.locationAccessTitleKey,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SafeArea(
          child: Builder(builder: (context) {
            if (permissionStatus == null || isGranted(permissionStatus)) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.pin_drop,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                          'The objective of this game is to get out and catch virtual shapes in your suroundings.\n'
                          '\n'
                          'The game will place these shapes nearby where you are in the world and then track your location to see when you get close enough to them.\n'
                          '\n'
                          'Therefore, to play this game, you need to grant access to the device location.'),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StadiumButton(
                            text: Text(
                              'Privacy policy',
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.grey[300]),
                            ),
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black54
                                    : Colors.grey[700],
                            primary: false,
                            onPressed: () {
                              showPrivacyPolicy();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                StadiumButton(
                  text: const Text('Ok'),
                  onPressed: () async {
                    final newStatus = await requestPermission();
                    if (!mounted) return;
                    if (newStatus == PermissionStatus.denied) {
                      final router = Routemaster.of(context);
                      await showAlert(
                          context,
                          const Text('Location access was denied'),
                          const Text(
                              'If you want to play this game, you have to go to the settings menu of your phone and enable location access for the game and then start a new game.'));
                      router.pop();
                      return;
                    }

                    setState(() {
                      permissionStatus = newStatus;
                    });

                    locatePlayerAndStartGame();
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> locatePlayerAndStartGame() async {
    var state = Provider.of<GameState>(context, listen: false);
    final router = Routemaster.of(context);

    final pos = await locatePlayer();
    if (!mounted) {
      return;
    }
    if (pos == null) {
      router.pop();
      return;
    }

    state.newGameFromLevel(pos, widget.level);
    state.playerPos = pos;
    router.push('/new-game/game');
  }

  Future<LatLng?> locatePlayer() async {
    LocationData? location;
    LatLng? pos;
    try {
      location = await getUserPosition();
      pos = location.toLatLng();
      if (pos == null) throw LocationDataError('');
    } catch (e) {
      if (!mounted) return null;
      if (e is PermissionError) {
        showAlert(
            context,
            const Text('No access'),
            const Text(
                'You need to grant access to location services to play this game.'));
        return null;
      } else {
        showAlert(context, const Text('Location error'),
            Text('An error occured wile obtaining your position: $e'));
        return null;
      }
    }
    return pos;
  }
}
