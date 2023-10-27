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

    //final screenHalfHeight = size.y / 2;
    final screenWidth = size.x;

    final imageWidth = screenWidth;
    final imageHeight = imageWidth / aspectRatio;

    topImage = SpriteComponent(
      sprite: spriteTop,
      position: Vector2(0, 0), // Top of the screen
      size: Vector2(imageWidth, imageHeight),
    );

    bottomImage = SpriteComponent(
      sprite: spriteBottom,
      position: Vector2(0, imageHeight), // Below the first image
      size: Vector2(imageWidth, imageHeight),
    );

    add(topImage);
    add(bottomImage);

    initDifferenceAreas(size.x, imageHeight);
    addCircleOverlays(circleSprite, imageHeight);
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
      Rect.fromPoints(Offset(imageWidth * 0.1, imageHeight * 0.2),
          Offset(imageWidth * 0.35, imageHeight * 0.45)),
      Rect.fromPoints(Offset(imageWidth * 0.5, imageHeight * 0.5),
          Offset(imageWidth * 0.85, imageHeight * 0.85)),
    ];
    remainingDifferences = differenceAreas.length;
  }

  void addCircleOverlays(Sprite circleSprite, double imageHeight) {
    for (var area in differenceAreas) {
      final circle1 = OverlayCircle(
        circleSprite,
        Vector2(area.left, area.top),
        Vector2(min(area.width, area.height), min(area.width, area.height)),
      );

      final circle2 = OverlayCircle(
        circleSprite,
        Vector2(area.left, area.top + imageHeight),
        Vector2(min(area.width, area.height), min(area.width, area.height)),
      );

      circle1.opacity = 0;
      circle2.opacity = 0;

      circleOverlaysTop.add(circle1);
      circleOverlaysBottom.add(circle2);

      add(circle1);
      add(circle2);
    }
  }

  void onDifferenceSpotted(Rect spottedArea) {}

  void onWrongTap() {}
}
