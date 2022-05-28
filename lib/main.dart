import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/screens/game/game_screen.dart';
import 'package:shapes_outdoor/screens/new_game/new_game_screen.dart';
import 'package:shapes_outdoor/theme/app_theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GameState()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: buildAppTheme(dark: false),
        darkTheme: buildAppTheme(dark: true),
        routerDelegate: RoutemasterDelegate(
          routesBuilder: (context) => RouteMap(routes: {
            '/': (routeData) => const MaterialPage(child: NewGameScreen()),
            '/game': (routeData) => const MaterialPage(child: GameScreen()),
          }),
        ),
        routeInformationParser: const RoutemasterParser(),
      ),
    );
  }
}
