import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/heart.dart';
import 'package:flutter_application_1/star.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/vignette_overlay.dart';
import 'package:flutter_application_1/wrong_tap.dart';
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
  List<Star> stars = [];

  // lives
  int lives = startingLives;
  List<Heart> hearts = [];

  late Sprite wrongSprite;

  @override
  Future<void> onLoad() async {
    final spriteTop = await Sprite.load(image1Path);
    final spriteBottom = await Sprite.load(image2Path);
    final circleSprite = await Sprite.load(circleImagePath);
    final vignette = await Sprite.load(vignetteImagePath);
    final heartSprite = await Sprite.load(heartImagePath);
    final starSprite = await Sprite.load(starImagePath);
    wrongSprite = await Sprite.load(wrongImagePath);

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
    addStars(starSprite);
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

    if (lives > 0) {
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

    if (foundDifference) {
      onDifferenceSpotted(tapPos, hasBeenFoundBefore);
    } else {
      onWrongTap(tapPos);
    }
  }

  void onDifferenceSpotted(Vector2 tapPos, bool hasBeenFoundBefore) {
    if (remainingDifferences > 0 && !hasBeenFoundBefore) {
      remainingDifferences--;
      updateStars(tapPos);
    }
  }

  void onWrongTap(Vector2 tapPos) {
    if (lives > 0) {
      lives--;
      updateHearts();
    }

    if (lives <= 0) {
      print("Game Over");
      // Implement your game-over logic here
    }

    final wrongTap = WrongTap(
      wrongSprite,
      tapPos,
      Vector2(50, 50),
    );

    add(wrongTap);
    wrongTap.playWrongTapAnimations();
  }

  void updateHearts() {
    if (lives >= 0 && lives < hearts.length) {
      hearts[lives].darken();
    }
  }

  void updateStars(Vector2 tapPos) {
    if (remainingDifferences >= 0 && remainingDifferences < hearts.length) {
      stars[remainingDifferences].lighten();
      createParticleAlongBezier(tapPos, stars[remainingDifferences].position);
    }
  }

  void createParticleAlongBezier(Vector2 startPos, Vector2 endPos) {
    var particles = Particle.generate(
      count: 15,
      generator: (i) => MovingParticle(
        from: startPos,
        to: endPos,
        curve: Curves.easeOutQuad,
        child: CircleParticle(
          radius: getRandomDouble(1.0, 2),
          lifespan: getRandomDouble(0.7, 7),
          paint: Paint()..color = Colors.white,
        ),
      ),
    );
    add(ParticleSystemComponent(
      particle: particles,
    ));
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

    // Don't forget to call super.render()
    super.render(canvas);
  }
}
