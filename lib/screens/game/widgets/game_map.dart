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
    final state = Provider.of<GameState>(context, listen: false);
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
          zoom: _zoom,
        ),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: dotenv.env['MAP_URL'],
              subdomains: ['a', 'b', 'c'],
              attributionBuilder: (_) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8.0)),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: const Text(
                    "© MapTiler, © OpenStreetMap contributors",
                    style: TextStyle(fontSize: 10.0),
                  ),
                );
              },
            ),
          ),
          Consumer<GameState>(
            builder: ((context, state, child) {
              return MarkerLayerWidget(
                options: MarkerLayerOptions(
                  key: ValueKey<String>(
                      '${state.playerPos} ${state.points.length}'),
                  markers: [
                    if (state.playerPos != null) playerMarker(state.playerPos!),
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
      builder: (context) => ShapeMarkerWidget(index, size),
    );
  }

  Marker playerMarker(LatLng playerPos) {
    return Marker(
      width: 14.0,
      height: 14.0,
      point: playerPos,
      builder: (context) => const PlayerMarkerWidget(),
    );
  }
}
