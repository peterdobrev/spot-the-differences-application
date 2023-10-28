import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_application_1/heart.dart';
import 'package:flutter_application_1/vignette_overlay.dart';
import 'constants.dart';
import 'overlay_circle.dart';

class DifferencesGame extends FlameGame with TapDetector {
  //images
  late SpriteComponent topImage;
  late SpriteComponent bottomImage;

  late VignetteOverlay vignetteOverlay;

  //difference areas
  List<Rect> differenceAreas = [];
  List<OverlayCircle> circleOverlaysTop = []; // first image
  List<OverlayCircle> circleOverlaysBottom = []; //second image
  int remainingDifferences = 0;

  // lives
  int lives = startingLives;
  List<Heart> hearts = [];

  @override
  Future<void> onLoad() async {
    final spriteTop = await Sprite.load(image1Path);
    final spriteBottom = await Sprite.load(image2Path);
    final circleSprite = await Sprite.load(circleImagePath);
    final vignette = await Sprite.load(vignetteImagePath);
    final heartSprite = await Sprite.load(heartImagePath);

    final screenWidth = size.x;
    final screenHeight = size.y;

    final imageWidth = screenWidth;
    final imageHeight = imageWidth / aspectRatio;

    final double totalHeight = (imageHeight * 2) + size.x * spaceBetweenImages;

    final double startingY = (screenHeight - totalHeight) / 2;

    vignetteOverlay = VignetteOverlay(
      vignette,
      Vector2.zero(),
      size,
    );

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

    add(vignetteOverlay);
    add(topImage);
    add(bottomImage);

    initDifferenceAreas(size.x, imageHeight);
    addCircleOverlays(circleSprite, imageHeight, startingY);
    addHearts(heartSprite);
  }

  void initDifferenceAreas(double imageWidth, double imageHeight) {
    differenceAreas = [
      Rect.fromPoints(Offset(imageWidth * 0.1, imageHeight * 0.1),
          Offset(imageWidth * 0.3, imageHeight * 0.3)),
      Rect.fromPoints(Offset(imageWidth * 0.6, imageHeight * 0.6),
          Offset(imageWidth * 0.8, imageHeight * 0.8)),
    ];
    remainingDifferences = differenceAreas.length;
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

      heart.setColor(const Color(0xFFFF0000)); // Initial color set to red
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
        Vector2(max(area.width, area.height), max(area.width, area.height)),
      );

      circleTop.opacity = 0;
      circleBottom.opacity = 0;

      circleOverlaysTop.add(circleTop);
      circleOverlaysBottom.add(circleBottom);

      add(circleTop);
      add(circleBottom);
    }
  }

  @override
  bool onTapDown(TapDownInfo info) {
    final tapPos = info.eventPosition.widget;

    bool foundDifference = false;

    for (int i = 0; i < circleOverlaysTop.length; i++) {
      if (circleOverlaysTop[i].toRect().contains(tapPos.toOffset()) ||
          circleOverlaysBottom[i].toRect().contains(tapPos.toOffset())) {
        circleOverlaysTop[i].opacity = 1.0;
        circleOverlaysBottom[i].opacity = 1.0;

        circleOverlaysTop[i].scaleUp();
        circleOverlaysBottom[i].scaleUp();

        foundDifference = true;
        break;
      }
    }

    if (foundDifference) {
    } else {
      onWrongTap();
    }

    return true;
  }

  void onDifferenceSpotted(Rect spottedArea) {}

  void onWrongTap() {
    if (lives > 0) {
      lives--;
      updateHearts();
    }

    if (lives <= 0) {
      print("Game Over");
      // Implement your game-over logic here
    }
  }

  void updateHearts() {
    if (lives >= 0 && lives < hearts.length) {
      hearts[lives].darken();
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw background
    canvas.drawRect(
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(size.x, size.y),
      ),
      Paint()..color = backgroundColor, // Set your desired color here
    );

    // Don't forget to call super.render()
    super.render(canvas);
  }
}