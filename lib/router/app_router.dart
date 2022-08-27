import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/game/game_screen.dart';
import 'package:shapes_outdoor/screens/new_game/new_game_screen.dart';
import 'package:shapes_outdoor/screens/start/start_screen.dart';
import 'package:shapes_outdoor/screens/start_location/start_location_screen.dart';

RouterDelegate<Object> appRouter() {
  return RoutemasterDelegate(
    routesBuilder: (context) => RouteMap(routes: {
      '/': (routeData) => const MaterialPage(child: StartScreen()),
      '/new-game': (routeData) => const MaterialPage(child: NewGameScreen()),
      '/new-game/:level/start-location': (routeData) {
        final levelStr = routeData.pathParameters['level'];
        final level = GameLevel.values
            .where((lvl) => lvl.toString().split('.').last == levelStr)
            .first;
        return MaterialPage(child: StartLocationScreen(level));
      },
      '/new-game/game': (routeData) => const MaterialPage(child: GameScreen()),
    }),
  );
}
