
import 'package:shapes_outdoor/models/game_state.dart';

String routeToStartLocation(GameLevel level) {
  final levelStr = level.toString().split('.').last;
  return '/new-game/$levelStr/start-location';
}