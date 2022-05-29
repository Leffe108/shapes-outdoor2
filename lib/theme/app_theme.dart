import 'package:flutter/material.dart';

ThemeData buildAppTheme({required bool dark}) {
  var theme = dark
      // Dark theme base
      ? ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green[700]!,
            background: Color.lerp(
                Color.lerp(Colors.green[900]!, Colors.brown, 0.3),
                Colors.black,
                0.5),
            brightness: Brightness.dark,
            secondary: Colors.blue[600],
          ),
        )
      // Light theme base
      : ThemeData(
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSwatch(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            backgroundColor: Colors.green[100],
            accentColor: Colors.blue[600],
          ),
        );

  // Common properties
  return theme.copyWith(
    // This makes the visual density adapt to the platform that you run
    // the app on. For desktop platforms, the controls will be smaller and
    // closer together (more dense) than on mobile platforms.
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
