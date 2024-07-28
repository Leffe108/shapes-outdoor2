import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/game/widgets/player_marker_widget.dart';
import 'package:shapes_outdoor/screens/game/widgets/shape_marker_widget.dart';

class GameMap extends StatefulWidget {
  const GameMap({Key? key}) : super(key: key);

  @override
  State<GameMap> createState() => _GameMapState();
}

const _zoom = 14.0;

class _GameMapState extends State<GameMap> {
  late final MapController mapController;
  bool mapReady = false;
  LatLng? center;

  @override
  void initState() {
    mapController = MapController();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // Center map on new player position if it is outside
    // the bounds of the current viewport.
    final state = Provider.of<GameState>(context, listen: true);
    if (center != state.playerPos && mapReady) {
      center = state.playerPos;
      if (center != null &&
          !mapController.camera.visibleBounds.contains(center!)) {
        mapController.move(center!, mapController.camera.zoom);
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<GameState>();
    final bounds = _gameBounds(state);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100,
        minWidth: 100,
      ),
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
          onMapReady: () => setState(() {
            mapReady = true;
          }),
          initialCenter: state.playerPos ?? const LatLng(0, 0),
          initialCameraFit: bounds != null
              ? CameraFit.bounds(
                  bounds: bounds,
                  padding: const EdgeInsets.all(50.0),
                  maxZoom: 16,
                )
              : null,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? const Color(0xFFE0E0E0)
              : Colors.black,
        ),
        children: [
          if (dotenv.isInitialized)
            TileLayer(
              userAgentPackageName: 'net.junctioneer.shapesoutdoor2',
              urlTemplate: Theme.of(context).brightness == Brightness.light
                  ? dotenv.env['MAP_URL']
                  : dotenv.env['MAP_URL_DARK'],
              subdomains: const ['a', 'b', 'c'],
            ),
          MarkerLayer(
            markers: [
              playerMarker(context),
            ],
          ),
          Builder(
            builder: ((context) {
              final state = context.watch<GameState>();
              return MarkerLayer(
                key: ValueKey<String>('${state.points.length}'),
                markers: [
                  for (var i = 0; i < state.points.length; i++)
                    shapeMarker(state.points[i], i),
                ],
              );
            }),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white.withOpacity(0.4)
                    : Colors.black.withOpacity(0.4),
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(8.0)),
              ),
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "© MapTiler, © OpenStreetMap contributors",
                style: TextStyle(
                  fontSize: 10.0,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[700]
                      : Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Marker shapeMarker(ShapePoint point, int index) {
    // Need to be quite large for TextButton to have content fully centered.
    const size = 60.0;
    return Marker(
      width: size,
      height: size,
      point: point.pos,
      child: ShapeMarkerWidget(index, point.shape, size),
    );
  }

  Marker playerMarker(BuildContext context) {
    final playerPos =
        context.select<GameState, LatLng?>((state) => state.playerPos);
    return Marker(
      width: 26.0,
      height: 26.0,
      point: playerPos ?? const LatLng(0, 0),
      child: const PlayerMarkerWidget(key: Key('player-marker')),
    );
  }
}

/// Get LatLngBounds of the game content
/// (player + points)
LatLngBounds? _gameBounds(GameState state) {
  if (state.playerPos == null && state.points.isEmpty) {
    return null;
  }
  return LatLngBounds.fromPoints([
    if (state.playerPos != null) state.playerPos!,
    ...state.points.map((sp) => sp.pos),
  ]);
}
