import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shapes_outdoor/screens/start/widgets/app_version.dart';
import 'package:shapes_outdoor/utils/privacy_policy.dart';
import 'package:shapes_outdoor/utils/settings_dialog.dart';
import 'package:shapes_outdoor/widgets/stadium_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  static const titleKey = Key('START_TITLE_KEY');
  static const startGameKey = Key('START_START_GAME');
  static const aboutKey = Key('START_ABOUT');
  static const settingsKey = Key('START_SETTINGS');
  static const aboutDialogKey = Key('START_ABOUT_DIALOG');

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    const margin = 50.0;
    const iconMargin = 10.0;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(iconMargin, margin, iconMargin,
            mq.size.height > 700 ? margin : iconMargin),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      margin - iconMargin, 0, margin - iconMargin, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Shapes Outdoor',
                        style: Theme.of(context).textTheme.headlineSmall,
                        key: titleKey,
                      ),
                      Expanded(child: Container()),
                      const SizedBox(height: 30),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: mq.size.height < 700
                              ? (mq.size.width - margin * 2) * 0.8
                              : double.infinity,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Routemaster.of(context).push('/new-game');
                          },
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black.withOpacity(0.10)
                                        : Colors.black.withOpacity(0.15),
                                    offset: const Offset(2, 2),
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: FadeIn(
                                duration: const Duration(milliseconds: 700),
                                child: Image.asset('assets/start-image.jpg'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                          'Collect shapes in your neigbourhood to complete this game.'),
                      const SizedBox(height: 20),
                      Expanded(child: Container()),
                      StadiumButton(
                        key: startGameKey,
                        text: const Text('Start game'),
                        onPressed: () {
                          Routemaster.of(context).push('/new-game');
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              buildIconButtons(context, margin - iconMargin),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIconButtons(BuildContext context, double height) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            key: settingsKey,
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              showSettingsDialog(context, inGame: false);
            },
          ),
          IconButton(
            key: aboutKey,
            icon: const Icon(Icons.question_mark),
            tooltip: 'About',
            onPressed: () {
              showAboutDialog(
                  applicationName: 'Shapes Outdoor',
                  context: context,
                  children: [
                    Row(
                      key: aboutDialogKey,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        AppVersion(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    StadiumButton(
                      text: const Text('Privacy Policy'),
                      onPressed: () {
                        showPrivacyPolicy();
                      },
                    ),
                  ]);
            },
          ),
        ],
      ),
    );
  }
}
