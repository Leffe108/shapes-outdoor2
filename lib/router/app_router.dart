import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/screens/game/game_screen.dart';
import 'package:shapes_outdoor/screens/new_game/new_game_screen.dart';
import 'package:shapes_outdoor/screens/start/start_screen.dart';

RouterDelegate<Object> appRouter() {
  return RoutemasterDelegate(
    routesBuilder: (context) => RouteMap(routes: {
      '/': (routeData) => const MaterialPage(child: StartScreen()),
      '/new-game': (routeData) => const MaterialPage(child: NewGameScreen()),
      '/new-game/game': (routeData) => const MaterialPage(child: GameScreen()),
    }),
  );
}
