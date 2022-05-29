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
  MapController? controller;
  LatLng? center;

  @override
  void didChangeDependencies() {
    // Center map on new player position if it is outside
    // the bounds of the current viewport.
    final state = Provider.of<GameState>(context, listen: true);
    if (center != state.playerPos && controller != null) {
      center = state.playerPos;
      if (center != null &&
          controller!.bounds != null &&
          !controller!.bounds!.contains(center)) {
        controller!.move(center!, controller!.zoom);
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<GameState>();
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100,
        minWidth: 100,
      ),
      child: FlutterMap(
        options: MapOptions(
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          controller: controller,
          onMapCreated: (c) {
            controller = c;
          },
          center: state.playerPos ?? LatLng(0, 0),
          bounds: _gameBounds(state),
          boundsOptions: const FitBoundsOptions(
            padding: EdgeInsets.all(50.0),
            maxZoom: 16,
          ),
        ),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: Theme.of(context).brightness == Brightness.light
                  ? dotenv.env['MAP_URL']
                  : dotenv.env['MAP_URL_DARK'],
              subdomains: ['a', 'b', 'c'],
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFE0E0E0)
                  : Colors.black,
              attributionBuilder: (_) {
                return Container(
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
                );
              },
            ),
          ),
          MarkerLayerWidget(
            options: MarkerLayerOptions(
              markers: [
                playerMarker(context),
              ],
            ),
          ),
          Builder(
            builder: ((context) {
              final state = context.watch<GameState>();
              return MarkerLayerWidget(
                options: MarkerLayerOptions(
                  key: ValueKey<String>('${state.points.length}'),
                  markers: [
                    for (var i = 0; i < state.points.length; i++)
                      shapeMarker(state.points[i], i),
                  ],
                ),
              );
            }),
          )
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
      builder: (context) => ShapeMarkerWidget(index, point.shape, size),
    );
  }

  Marker playerMarker(BuildContext context) {
    final playerPos =
        context.select<GameState, LatLng?>((state) => state.playerPos);
    return Marker(
      width: 26.0,
      height: 26.0,
      point: playerPos ?? LatLng(0, 0),
      builder: (context) => const PlayerMarkerWidget(key: Key('player-marker')),
    );
  }
}

/// Get LatLngBounds of the game content
/// (player + points)
LatLngBounds _gameBounds(GameState state) {
  var b = LatLngBounds();
  b.extend(state.playerPos);
  for (var point in state.points) {
    b.extend(point.pos);
  }
  return b;
}
