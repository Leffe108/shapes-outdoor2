import 'package:flutter/material.dart';
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

class _GameMapState extends State<GameMap> {
  MapController? controller;
  LatLng? center;

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
          controller: controller,
          onMapCreated: (c) {
            controller = c;
          },
          center: state.playerPos ?? LatLng(0, 0),
          zoom: 14,
        ),
        children: [
          TileLayerWidget(
            options: TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              attributionBuilder: (_) {
                return const Text("© OpenStreetMap contributors");
              },
            ),
          ),
          Consumer<GameState>(
            builder: ((context, state, child) {
              return MarkerLayerWidget(
                options: MarkerLayerOptions(
                  key: ValueKey<String>(
                      '${state.playerPos} ${state.shapesToCollect.length}'),
                  markers: [
                    if (state.playerPos != null) playerMarker(state.playerPos!),
                    for (var i = 0; i < state.shapesToCollect.length; i++)
                      shapeMarker(state.shapesToCollect[i], i),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Marker shapeMarker(Poi poi, int index) {
    return Marker(
      width: 20.0,
      height: 20.0,
      point: poi.pos,
      builder: (context) => ShapeMarkerWidget(index),
    );
  }

  Marker playerMarker(LatLng playerPos) {
    return Marker(
      width: 12.0,
      height: 12.0,
      point: playerPos,
      builder: (context) => const PlayerMarkerWidget(),
    );
  }
}
