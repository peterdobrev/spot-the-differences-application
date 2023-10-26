import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/differences_game.dart';

void main() {
  final game = DifferencesGame();
  runApp(GameWidget(game: game));
}
