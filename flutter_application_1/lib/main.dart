import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/differences_game.dart';
import 'package:flutter_application_1/overlays/game_over.dart';
import 'package:flutter_application_1/overlays/level_complete.dart';
import 'package:flutter_application_1/overlays/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Flame.device.fullScreen();
  Flame.device.setPortrait();

  runApp(
    GameWidget<DifferencesGame>.controlled(
      gameFactory: DifferencesGame.new,
      overlayBuilderMap: {
        mainMenuOverlayIdentifier: (_, game) => MainMenu(game: game),
        gameOverOverlayIdentifier: (_, game) => GameOver(game: game),
        levelCompleteOverlayIdentifier: (_, game) => LevelComplete(game: game),
      },
      initialActiveOverlays: const [mainMenuOverlayIdentifier],
    ),
  );
}
