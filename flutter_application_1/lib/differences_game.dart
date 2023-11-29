import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/background_layer.dart';
import 'package:flutter_application_1/firework.dart';
import 'package:flutter_application_1/heart.dart';
import 'package:flutter_application_1/levels_data.dart';
import 'package:flutter_application_1/star.dart';
import 'package:flutter_application_1/wrong_tap.dart';
import 'constants.dart';
import 'overlay_circle.dart';
import 'game_state.dart';

class DifferencesGame extends FlameGame with TapDetector {
  GameState gameState = GameState();
  //images
  late SpriteComponent topImage;
  late SpriteComponent bottomImage;

  late BackgroundLayer vignetteOverlay;

  //difference areas
  List<Rect> differenceAreas = [];
  List<OverlayCircle> circleOverlaysTop = []; // first image
  List<OverlayCircle> circleOverlaysBottom = []; //second image
  List<Star> stars = [];

  // lives
  List<Heart> hearts = [];

  late Sprite wrongSprite;

  @override
  Future<void> onLoad() async {
    final vignette = await Sprite.load(vignetteImagePath);
    vignetteOverlay = BackgroundLayer(vignette, size);

    await FlameAudio.audioCache.loadAll([
      correctTapSound,
      wrongTapSound,
      levelCompleteSound,
      gameOverSound,
    ]);

    await loadLevel();
  }

  Future<void> loadLevel() async {
    resetGameState();
    final spriteTop =
        await Sprite.load(levels[gameState.currentLevelIndex].topImagePath);
    final spriteBottom =
        await Sprite.load(levels[gameState.currentLevelIndex].bottomImagePath);
    final circleSprite = await Sprite.load(circleImagePath);
    final heartSprite = await Sprite.load(heartImagePath);
    final starSprite = await Sprite.load(starImagePath);
    wrongSprite = await Sprite.load(wrongImagePath);

    final screenWidth = size.x;
    final screenHeight = size.y;

    final imageWidth = screenWidth;
    final imageHeight = imageWidth / aspectRatio;

    final double totalHeight = (imageHeight * 2) + size.x * spaceBetweenImages;

    final double startingY = (screenHeight - totalHeight) / 2;

    topImage = SpriteComponent(
      sprite: spriteTop,
      position: Vector2(0, startingY), // Adjusted position
      size: Vector2(imageWidth, imageHeight),
    );

    bottomImage = SpriteComponent(
      sprite: spriteBottom,
      position: Vector2(
          0,
          startingY +
              imageHeight +
              size.x * spaceBetweenImages), // Adjusted position
      size: Vector2(imageWidth, imageHeight),
    );

    add(topImage);
    add(bottomImage);

    initDifferenceAreas(size.x, imageHeight);
    addCircleOverlays(circleSprite, imageHeight, startingY);
    addHearts(heartSprite);
    addStars(starSprite);
  }

  void initDifferenceAreas(double imageWidth, double imageHeight) {
    for (var element in levels[gameState.currentLevelIndex].differences) {
      differenceAreas.add(Rect.fromPoints(
          Offset(element.left * imageWidth, element.top * imageHeight),
          Offset(element.right * imageWidth, element.bottom * imageHeight)));
    }
    gameState.remainingDifferences = differenceAreas.length;
  }

  void addHearts(Sprite heartSprite) {
    for (int i = 0; i < startingLives; i++) {
      final heart = Heart(
        heartSprite,
        Vector2((size.x * heartsRatioToScreenWidth),
            (size.x * heartsRatioToScreenWidth)),
        Vector2(
            i *
                    (size.x * heartsRatioToScreenWidth +
                        additionalPixelOffsetHearts) +
                size.x * ratioOffsetHeartsScreenWidth,
            size.y *
                ratioOffsetHeartsScreenHeight), //equation is the gap between each heart
      );

      hearts.add(heart);
      add(heart);
    }
  }

  void addCircleOverlays(
      Sprite circleSprite, double imageHeight, double startingY) {
    for (var area in differenceAreas) {
      final circleTop = OverlayCircle(
        circleSprite,
        Vector2(area.left, area.top + startingY),
        Vector2(max(area.width, area.height), max(area.width, area.height)),
      );

      final circleBottom = OverlayCircle(
          circleSprite,
          Vector2(area.left,
              area.top + imageHeight + startingY + size.x * spaceBetweenImages),
          Vector2(max(area.width, area.height), max(area.width, area.height)));

      circleTop.opacity = 0;
      circleBottom.opacity = 0;

      circleOverlaysTop.add(circleTop);
      circleOverlaysBottom.add(circleBottom);

      add(circleTop);
      add(circleBottom);
    }
  }

  void addStars(Sprite starSprite) {
    for (int i = 0; i < differenceAreas.length; i++) {
      double starWidth = size.x * starsRatioToScreenWidth;
      double starHeight = size.x * starsRatioToScreenWidth;

      double totalWidth = (starWidth) * differenceAreas.length;

      double startX = (size.x - totalWidth) / 2.0;

      double centerY = size.y / 2.0;

      final star = Star(
        starSprite,
        Vector2(starWidth, starHeight),
        Vector2(
          startX +
              (i + 1 / 2) *
                  (starWidth), //this 1/2 is needed to center the stars correctly
          centerY,
        ),
      );

      stars.add(star);
      add(star);
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    final tapPos = info.eventPosition.widget;

    if (gameState.lives > 0) {
      if (isTapOnImage(tapPos)) {
        handleImageTap(tapPos);
      }
    }

    return true;
  }

  bool isTapOnImage(Vector2 tapPos) {
    return topImage.toRect().contains(tapPos.toOffset()) ||
        bottomImage.toRect().contains(tapPos.toOffset());
  }

  void handleImageTap(Vector2 tapPos) {
    bool foundDifference = false;
    bool hasBeenFoundBefore = false;

    /*bool isTopImage = topImage.toRect().contains(tapPos.toOffset());
    bool isBottomImage = bottomImage.toRect().contains(tapPos.toOffset());*/

    for (int i = 0; i < circleOverlaysTop.length; i++) {
      if (circleOverlaysTop[i].toRect().contains(tapPos.toOffset()) ||
          circleOverlaysBottom[i].toRect().contains(tapPos.toOffset())) {
        circleOverlaysTop[i].opacity = 1.0;
        circleOverlaysBottom[i].opacity = 1.0;

        if (circleOverlaysTop[i].hasBeenClicked ||
            circleOverlaysBottom[i].hasBeenClicked) {
          hasBeenFoundBefore = true;
        }

        circleOverlaysTop[i].scaleUp();
        circleOverlaysBottom[i].scaleUp();

        foundDifference = true;
        break;
      }
    }

    /*if (isTopImage || isBottomImage) {
      Rect imageRect = isTopImage ? topImage.toRect() : bottomImage.toRect();
      Vector2 normalizedPos = Vector2(
        (tapPos.x - imageRect.left) / imageRect.width,
        (tapPos.y - imageRect.top) / imageRect.height,
      );
      print("Normalized Tap Position: $normalizedPos");
    }*/

    if (foundDifference) {
      onDifferenceSpotted(tapPos, hasBeenFoundBefore);
    } else {
      onWrongTap(tapPos);
    }
  }

  void onDifferenceSpotted(Vector2 tapPos, bool hasBeenFoundBefore) {
    if (gameState.remainingDifferences > 0 && !hasBeenFoundBefore) {
      gameState.remainingDifferences--;
      updateStars(tapPos);
      FlameAudio.play(correctTapSound);
    }

    if (gameState.remainingDifferences <= 0) {
      onLevelCompleted();
    }
  }

  Future<void> onLevelCompleted() async {
    if (kDebugMode) {
      print('Level completed!');
    }
    await Future.delayed(const Duration(milliseconds: 700));
    overlays.add(levelCompleteOverlayIdentifier);
  }

  Future<void> nextLevel() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Increment the current level index to load the next level
    // Make sure to handle the scenario where this is the last level
    gameState.currentLevelIndex++;
    if (gameState.currentLevelIndex >= levels.length) {
      // Handle the case when all levels are complete
      // Maybe go back to the first level or show a completion screen
      gameState.currentLevelIndex =
          0; // Looping back to first level for example
    }

    removeLastLevelImages();
    // Call loadLevel to load the next level
    await loadLevel();
  }

  Future<void> onLevelFail() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (kDebugMode) {
      print('Level failed!');
    }
    overlays.add(gameOverOverlayIdentifier);
  }

  Future<void> resetLevel() async {
    await Future.delayed(const Duration(milliseconds: 500));

    removeLastLevelImages();
    // Call loadLevel to load the next level
    await loadLevel();
  }

  void onWrongTap(Vector2 tapPos) {
    if (gameState.lives > 0) {
      gameState.lives--;
      updateHearts();
    }

    if (gameState.lives <= 0) {
      onLevelFail();
    }

    final wrongTap = WrongTap(
      wrongSprite,
      tapPos,
      Vector2(50, 50),
    );

    add(wrongTap);
    wrongTap.playEffects();
  }

  void updateHearts() {
    if (gameState.lives >= 0 && gameState.lives < hearts.length) {
      hearts[gameState.lives].darken();
    }
  }

  void updateStars(Vector2 tapPos) {
    if (gameState.remainingDifferences >= 0 &&
        gameState.remainingDifferences < hearts.length) {
      stars[gameState.remainingDifferences].lighten();
      stars[gameState.remainingDifferences].scaleUp();
      playFireworkParticles(stars[gameState.remainingDifferences].position);
    }
  }

  void playFireworkParticles(Vector2 position) {
    add(
      ParticleSystemComponent(
        particle: fireworkParticle(),
        position: position,
      ),
    );
  }

  void resetGameState() {
    differenceAreas.clear();
    circleOverlaysTop.clear();
    circleOverlaysBottom.clear();
    stars.clear();
    hearts.clear();

    gameState.reset();
  }

  void removeLastLevelImages() {
    remove(topImage);
    remove(bottomImage);
    removeAll(circleOverlaysBottom);
    removeAll(circleOverlaysTop);
    removeAll(stars);
  }

  @override
  void render(Canvas canvas) {
    // Draw background
    canvas.drawRect(
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(size.x, size.y),
      ),
      Paint()..color = backgroundColor,
    );

    vignetteOverlay.render(canvas);
    // Don't forget to call super.render()
    super.render(canvas);
  }
}
