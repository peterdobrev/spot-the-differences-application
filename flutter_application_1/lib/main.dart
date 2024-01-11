import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/differences_game.dart';
import 'package:flutter_application_1/overlays/game_over.dart';
import 'package:flutter_application_1/overlays/level_complete.dart';
import 'package:flutter_application_1/overlays/main_menu.dart';
import 'package:flutter_application_1/overlays/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setPortrait();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlameSplashScreen(
        theme: FlameSplashTheme.dark,
        showBefore: (BuildContext context) {
          return Container(
              color: Colors.black,
              child: const Center(
                  child: Image(
                image: AssetImage('assets/images/splash_screen_logo.png'),
                height: 171,
                width: 128,
              )));
        },
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
      overlayBuilderMap: {
        mainMenuOverlayIdentifier: (_, game) => MainMenu(game: game),
        gameOverOverlayIdentifier: (_, game) => GameOver(game: game),
        levelCompleteOverlayIdentifier: (_, game) => LevelComplete(game: game),
        settingsOverlayIdentifier: (_, game) => SettingsScreen(game: game),
      },
      initialActiveOverlays: const [mainMenuOverlayIdentifier],
    );
  }
}
