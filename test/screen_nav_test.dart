// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/main.dart';
import 'package:shapes_outdoor/models/game_state.dart';
import 'package:shapes_outdoor/models/settings.dart';
import 'package:shapes_outdoor/models/vibration.dart';
import 'package:shapes_outdoor/screens/game/game_screen.dart';
import 'package:shapes_outdoor/screens/new_game/new_game_screen.dart';
import 'package:shapes_outdoor/screens/new_game/widgets/game_menu.dart';
import 'package:shapes_outdoor/screens/start/start_screen.dart';
import 'package:shapes_outdoor/screens/start_location/start_location_screen.dart';

void main() {
  testWidgets('Screen nav test', (WidgetTester tester) async {
    final settings = Settings(useSharedPreferences: false);
    settings.backgroundLocation.value = false;
    settings.vibrate.value = false;
    final vibration = Vibration(setting: settings.vibrate);
    final gameState = GameState(vibration: vibration);

    const mockAppName = 'SO2';
    const mockVersion = '1.0.0';
    PackageInfo.setMockInitialValues(
      appName: mockAppName,
      packageName: 'com.example',
      version: mockVersion,
      buildNumber: '1',
      buildSignature: '',
      installerStore: '',
    );

    Location.instance = MockLocationPlatform();

    // Build our app and trigger a frame.
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: gameState,
        ),
        Provider<Settings>.value(value: settings),
      ],
      child: const MyApp(),
    ));

    await tester.pumpAndSettle();

    // Verify start page
    expect(find.byKey(StartScreen.titleKey), findsOneWidget);
    expect(find.byKey(StartScreen.startGameKey), findsOneWidget);
    expect(find.byKey(StartScreen.settingsKey), findsOneWidget);
    expect(find.byKey(StartScreen.aboutKey), findsOneWidget);
    expect(find.text('Version'), findsNothing);
    expect(find.text('Settings'), findsNothing);

    // Open about dialog, verify it was opened and close
    await tester.tap(find.byKey(StartScreen.aboutKey));
    await tester.pumpAndSettle();
    expect(find.byKey(StartScreen.aboutDialogKey), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Open settings dialog, verify it was opened and close
    await tester.tap(find.byKey(StartScreen.settingsKey));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('CLOSE'));
    await tester.pumpAndSettle();

    // Navigate to level selection
    await tester.tap(find.byKey(StartScreen.startGameKey));
    await tester.pumpAndSettle();
    expect(find.byKey(NewGameScreen.titleKey), findsOneWidget);
    expect(find.byKey(GameMenu.miniKey), findsOneWidget);

    // Select mini level => navigate to start location screen
    await tester.tap(find.byKey(GameMenu.miniKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(StartLocationScreen.locationAccessTitleKey),
      findsOneWidget,
    );
    expect(gameState.nextShape, isNull);
    expect(gameState.playerPos, isNull);

    // Answer OK to trigger permission request
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    // A spinner is shown while UI requests the location, so pumpAndSettle will return
    // once location has been obtained and user has navigated to the game screen.
    expect(find.byKey(GameScreen.titleKey), findsOneWidget);
    expect(gameState.nextShape, isNotNull);
    expect(gameState.playerPos, isNotNull);

    // Close the game - game menu should offert to abort the game
    await tester.tap(find.byKey(GameScreen.closeKey));
    await tester.pumpAndSettle();
    expect(find.byKey(GameMenu.abortGameKey), findsOneWidget);
    expect(find.byKey(GameMenu.resumeGameKey), findsOneWidget);

    // Resume game and then go back to menu again
    await tester.tap(find.byKey(GameMenu.resumeGameKey));
    await tester.pumpAndSettle();
    expect(find.byKey(GameScreen.titleKey), findsOneWidget);
    await tester.tap(find.byKey(GameScreen.closeKey));
    await tester.pumpAndSettle();
    expect(find.byKey(GameMenu.abortGameKey), findsOneWidget);
    expect(find.byKey(GameMenu.resumeGameKey), findsOneWidget);

    // Abort game - should then be offered to start new game
    await tester.tap(find.byKey(GameMenu.abortGameKey));
    await tester.pumpAndSettle();
    expect(find.byKey(GameMenu.miniKey), findsOneWidget);
  });
}

class MockLocationPlatform with MockPlatformInterfaceMixin implements Location {
  bool _hasPermission = false;

  @override
  Future<PermissionStatus> hasPermission() async {
    return _hasPermission ? PermissionStatus.granted : PermissionStatus.denied;
  }

  @override
  Future<PermissionStatus> requestPermission() async {
    _hasPermission = true;
    return PermissionStatus.granted;
  }

  @override
  Future<LocationData> getLocation() async => Future.delayed(
        const Duration(milliseconds: 50),
        () => LocationData.fromMap({
          'latitude': 0.0,
          'longitude': 0.0,
          'isMock': true,
        }),
      );

  @override
  Stream<LocationData> get onLocationChanged async* {
    final loc = await getLocation();
    yield loc;
  }

  @override
  Future<AndroidNotificationData?> changeNotificationOptions({
    String? channelName,
    String? title,
    String? iconName,
    String? subtitle,
    String? description,
    Color? color,
    bool? onTapBringToFront,
  }) async {
    return null;
  }

  @override
  Future<bool> changeSettings({
    LocationAccuracy? accuracy,
    int? interval,
    double? distanceFilter,
  }) async {
    return true;
  }

  @override
  Future<bool> enableBackgroundMode({bool? enable}) async {
    return true;
  }

  @override
  Future<bool> isBackgroundModeEnabled() async {
    return true;
  }

  @override
  Future<bool> requestService() async {
    return true;
  }

  @override
  Future<bool> serviceEnabled() async {
    return true;
  }
}
