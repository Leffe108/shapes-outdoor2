// Test of speak util and Speak model

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shapes_outdoor/widgets/stadium_button.dart';

const buttonKey = Key('BUTTON_KEY');
const buttonText = 'Hello Stadium';

void main() {
  testWidgets('StadiumButton widget test', (WidgetTester tester) async {
    var state = false;
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: StadiumButton(
        key: buttonKey,
        text: const Text(buttonText),
        onPressed: () {
          state = true;
        },
      ),
    ));

    expect(find.byKey(buttonKey), findsOneWidget);
    expect(find.text(buttonText), findsOneWidget);
    expect(state, false);

    await tester.tap(find.byKey(buttonKey));
    await tester.pumpAndSettle();
    expect(state, true);
    expect(find.byKey(buttonKey), findsOneWidget);
  });
}
