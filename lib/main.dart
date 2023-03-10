import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/models/settings.dart';
import 'package:shapes_outdoor/models/vibration.dart';
import 'package:shapes_outdoor/router/app_router.dart';
import 'package:shapes_outdoor/theme/app_theme.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  final settings = Settings();
  final vibration = Vibration(setting: settings.vibrate);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => GameState(vibration: vibration),
      ),
      Provider<Settings>.value(value: settings),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: buildAppTheme(dark: false),
      darkTheme: buildAppTheme(dark: true),
      routerDelegate: appRouter(),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
