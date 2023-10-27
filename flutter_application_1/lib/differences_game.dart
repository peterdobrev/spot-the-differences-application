import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'constants.dart';
import 'overlay_circle.dart';

class DifferencesGame extends FlameGame with TapDetector {
  late SpriteComponent topImage;
  late SpriteComponent bottomImage;
  List<Rect> differenceAreas = [];
  List<SpriteComponent> circleOverlaysTop = []; // first image
  List<SpriteComponent> circleOverlaysBottom = []; //second image
  int remainingDifferences = 0;
  int lives = 3;

  @override
  Future<void> onLoad() async {
    final spriteTop = await Sprite.load(image1Path);
    final spriteBottom = await Sprite.load(image2Path);
    final circleSprite = await Sprite.load(circleImagePath);

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
  }

  @override
  bool onTapDown(TapDownInfo info) {
    final tapPos = info.eventPosition.widget;

    for (int i = 0; i < circleOverlaysTop.length; i++) {
      if (circleOverlaysTop[i].toRect().contains(tapPos.toOffset()) ||
          circleOverlaysBottom[i].toRect().contains(tapPos.toOffset())) {
        circleOverlaysTop[i].opacity = 1.0;
        circleOverlaysBottom[i].opacity = 1.0;
        break;
      }
    }
    return true;
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

  void addCircleOverlays(
      Sprite circleSprite, double imageHeight, double startingY) {
    for (var area in differenceAreas) {
      final circleTop = OverlayCircle(
        circleSprite,
        Vector2(area.left, area.top + startingY),
        Vector2(min(area.width, area.height), min(area.width, area.height)),
      );

      final circleBottom = OverlayCircle(
        circleSprite,
        Vector2(area.left,
            area.top + imageHeight + startingY + size.x * spaceBetweenImages),
        Vector2(min(area.width, area.height), min(area.width, area.height)),
      );

      circleTop.opacity = 0;
      circleBottom.opacity = 0;

      circleOverlaysTop.add(circleTop);
      circleOverlaysBottom.add(circleBottom);

      add(circleTop);
      add(circleBottom);
    }
  }

  void onDifferenceSpotted(Rect spottedArea) {}

  void onWrongTap() {}
}
