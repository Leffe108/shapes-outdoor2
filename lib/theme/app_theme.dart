import 'package:flutter/material.dart';

ThemeData buildAppTheme({required bool dark}) {
  var theme = dark
      // Dark theme base
      ? _dark()
      // Light theme base
      : _light();

  // Common properties
  return theme.copyWith(
    // This makes the visual density adapt to the platform that you run
    // the app on. For desktop platforms, the controls will be smaller and
    // closer together (more dense) than on mobile platforms.
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // Make SwitchListTile use primary color and not default teal color
    toggleableActiveColor: theme.colorScheme.primary,
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(theme.colorScheme.primary),
    ),
  );
}

_light() {
  final bgColor = Colors.green[200];

  return ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      backgroundColor: bgColor,
      accentColor: Colors.blue[600],
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bgColor,
      foregroundColor: Colors.grey[900],
    ),
  );
}

_dark() {
  final bgColor = Color.lerp(
      Color.lerp(Colors.green[900]!, Colors.brown, 0.3), Colors.black, 0.5);

  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green[700]!,
      background: bgColor,
      brightness: Brightness.dark,
      secondary: Colors.blue[600],
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: bgColor,
      foregroundColor: Colors.white,
    ),
  );
}
