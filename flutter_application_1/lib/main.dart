import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/game_logic/differences_game.dart';
import 'package:flutter_application_1/overlay_screens/game_over.dart';
import 'package:flutter_application_1/overlay_screens/level_complete.dart';
import 'package:flutter_application_1/overlay_screens/main_menu.dart';
import 'package:flutter_application_1/overlay_screens/settings_screen.dart';
import 'package:flutter_application_1/utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up the Flame device configurations
  Flame.device.fullScreen();
  Flame.device.setPortrait();

  // Initialize error handling
  FlutterError.onError = (details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlameSplashScreen(
        theme: FlameSplashTheme.dark,
        // Custom splash screen before game loads
        showBefore: (BuildContext context) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: Image(
                image: AssetImage('assets/images/splash_screen_logo.png'),
                height: 171,
                width: 128,
              ),
            ),
          );
        },
        // Transition to the main game screen after splash
        onFinish: (context) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GameScreen()),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget<DifferencesGame>.controlled(
      gameFactory: DifferencesGame.new,
      // Map overlays to their respective widgets
      overlayBuilderMap: {
        mainMenuOverlayIdentifier: (_, game) => MainMenu(game: game),
        gameOverOverlayIdentifier: (_, game) => GameOver(game: game),
        levelCompleteOverlayIdentifier: (_, game) => LevelComplete(game: game),
        settingsOverlayIdentifier: (_, game) => SettingsScreen(game: game),
      },
      // Start with the main menu overlay
      initialActiveOverlays: const [mainMenuOverlayIdentifier],
    );
  }
}
