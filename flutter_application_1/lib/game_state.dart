import 'package:flutter_application_1/constants.dart';

class GameState {
  int currentLevelIndex = 0;
  int lives = startingLives;
  int remainingDifferences = 0;

  // Other game state variables

  void reset() {
    // Reset logic
    lives = startingLives;
    remainingDifferences = 0;
  }

  // Other logic methods
}
