import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/background_layer.dart';
import 'package:flutter_application_1/firework.dart';
import 'package:flutter_application_1/heart.dart';
import 'package:flutter_application_1/hint_twinkle.dart';
import 'package:flutter_application_1/levels_data.dart';
import 'package:flutter_application_1/star.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/wrong_tap.dart';
import 'constants.dart';
import 'overlay_circle.dart';
import 'game_state.dart';

class DifferencesGame extends FlameGame
    with MultiTouchTapDetector, ScaleDetector {
  GameState gameState = GameState();

  bool isZooming = false;
  late Vector2 zoomPosition;
  late Vector2 originalSrcSize;
  late Vector2 originalSrcPosition;
  DateTime _lastScaleTime = DateTime.now();
  //images
  late PositionComponent topImage;
  late PositionComponent bottomImage;

  late PositionComponent topImageContainer;
  late PositionComponent bottomImageContainer;

  late BackgroundLayer vignetteOverlay;

  late Sprite wrongSprite;
  late Sprite heartSprite;
  late Sprite starSprite;
  late Sprite hintSprite;
  late Sprite circleSprite;

  late SpriteButtonComponent hintButton;

  //late ButtonComponent hintButton;

  //difference areas
  List<Rect> differenceAreas = [];
  List<OverlayCircle> circleOverlaysTop = []; // first image
  List<OverlayCircle> circleOverlaysBottom = []; //second image
  List<Star> stars = [];

  // lives
  List<Heart> hearts = [];

  List<HintTwinkle> hintTwinkles = [];

  @override
  Future<void> onLoad() async {
    final vignette = await Sprite.load(vignetteImagePath);
    vignetteOverlay = BackgroundLayer(vignette, size);

    circleSprite = await Sprite.load(circleImagePath);
    heartSprite = await Sprite.load(heartImagePath);
    starSprite = await Sprite.load(starImagePath);
    wrongSprite = await Sprite.load(wrongImagePath);
    hintSprite = await Sprite.load(hintImagePath);

    final hintButtonSprite = await Sprite.load(hintButtonImagePath);
    addHintButton(hintButtonSprite);

    await FlameAudio.audioCache.loadAll([
      correctTapSound,
      wrongTapSound,
      levelCompleteSound,
      gameOverSound,
    ]);

    await loadLevel();
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    final currentTime = DateTime.now();
    if (currentTime.difference(_lastScaleTime).inMilliseconds < 20 ||
        gameState.remainingDifferences <= 0) {
      // If less than 20 milliseconds has passed, ignore this cycle or if the game is over
      return;
    }
    _lastScaleTime = currentTime; // Update the last scale time

    isZooming = true;
    zoomPosition = info.raw.focalPoint.toVector2();

    if (!isTapOnAnyImage(zoomPosition)) {
      isZooming = false;
      return;
    }
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (DateTime.now().difference(_lastScaleTime).inMilliseconds < 20 ||
        gameState.remainingDifferences <= 0) {
      // If less than 20 milliseconds has passed, ignore this cycle
      return;
    }

    if (isZooming = false) {
      return;
    }

    imageZoom = max(1, min(3, info.scale.global.y));
    Vector2 normalizedZoomPos = getNormalizedImagePos(zoomPosition);
      Vector2 topLeft = Vector2(
      );

      final srcRect = Rect.fromLTWH(
        topLeft.x,
        topLeft.y,
        zoomedSize.x,
        zoomedSize.y,
      return srcRect;
    topImage.scale = Vector2(imageZoom, imageZoom);
    bottomImage.scale = Vector2(imageZoom, imageZoom);
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    if (DateTime.now().difference(_lastScaleTime).inMilliseconds < 20 ||
        gameState.remainingDifferences <= 0) {
      // If less than 20 milliseconds has passed, ignore this cycle
      return;
    }
    _lastScaleTime = DateTime.now(); // Update the last scale time

    resetZoom();  }

  Future<void> resetZoom() async {
    isZooming = false;
    
    print(circleOverlaysTop.first.position);
  }


  void addHintButton(Sprite hintButtonSprite) {
    hintButton = SpriteButtonComponent(
        button: hintButtonSprite,
        buttonDown: circleSprite,
        size: Vector2(60, 60),
        position: Vector2(size.x / 2, size.y - 60),
        anchor: Anchor.center);

    add(hintButton);
  }

  Future<void> loadLevel() async {
    resetGameState();
    final spriteTop =
        await Sprite.load(levels[gameState.currentLevelIndex].topImagePath);
    final spriteBottom =
        await Sprite.load(levels[gameState.currentLevelIndex].bottomImagePath);

    final screenWidth = size.x;
    final screenHeight = size.y;

    final imageWidth = screenWidth;
    final imageHeight = imageWidth / aspectRatio;

    final double totalHeight = (imageHeight * 2) + size.x * spaceBetweenImages;

    final double startingY = (screenHeight - totalHeight) / 2;


    topImageContainer = ClipComponent.rectangle(
      position: Vector2(0, startingY), // Adjusted position
      size: Vector2(imageWidth, imageHeight),
      children: [topImage = PositionComponent(children: [SpriteComponent(sprite: spriteTop, size: Vector2(imageWidth, imageHeight))])],
    );
    
    bottomImageContainer = ClipComponent.rectangle(
      position: Vector2(0, startingY + imageHeight + size.x * spaceBetweenImages), // Adjusted position
      size: Vector2(imageWidth, imageHeight),
      children: [bottomImage = PositionComponent(children: [SpriteComponent(sprite: spriteBottom, size: Vector2(imageWidth, imageHeight))])],
    );


    add(topImageContainer);
    add(bottomImageContainer);

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
        Vector2(area.left, area.top),
        Vector2(max(area.width, area.height), max(area.width, area.height)));

      final circleBottom = OverlayCircle(
        circleSprite,
        Vector2(area.left, area.top),
        Vector2(max(area.width, area.height), max(area.width, area.height)));

      circleTop.opacity = 1;
      circleBottom.opacity = 1;

      circleOverlaysTop.add(circleTop);
      circleOverlaysBottom.add(circleBottom);

      topImage.add(circleTop);
      bottomImage.add(circleBottom);
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
  void onTapUp(int pointerId, TapUpInfo info) {

    final tapPos = info.eventPosition.widget;

    if (gameState.lives > 0 && gameState.remainingDifferences > 0) {
      if (isTapOnAnyImage(tapPos)) {
        handleImageTap(tapPos);
      } else if (isTapOnButton(tapPos, hintButton)) {
        displayHint();
      }
    }
  }

  bool isTapOnAnyImage(Vector2 tapPos) {
    return isTapOnImage(tapPos, topImageContainer) || isTapOnImage(tapPos, bottomImageContainer);
  }

  void handleImageTap(Vector2 tapPos) {
    bool foundDifference = false;
    bool hasBeenFoundBefore = false;

    bool isTopImage = topImageContainer.toRect().contains(tapPos.toOffset());
    bool isBottomImage = bottomImageContainer.toRect().contains(tapPos.toOffset());

    Vector2 imageTapPos = Vector2.zero();
    if (isTopImage || isBottomImage) {
      Rect imageRect = isTopImage ? topImageContainer.toRect() : bottomImageContainer.toRect();
      imageTapPos = Vector2(
        (tapPos.x - imageRect.left) / imageZoom,
        (tapPos.y - imageRect.top) / imageZoom,
      );
    }

    for (int i = 0; i < circleOverlaysTop.length; i++) {
      if (circleOverlaysTop[i].toRect().contains(imageTapPos.toOffset()) ||
          circleOverlaysBottom[i].toRect().contains(imageTapPos.toOffset())) {
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

  Vector2 getNormalizedImagePos(Vector2 pos) {
    bool isTopImage = topImageContainer.toRect().contains(pos.toOffset());
    bool isBottomImage = bottomImageContainer.toRect().contains(pos.toOffset());

    Vector2 normalizedPos = Vector2.zero();
    if (isTopImage || isBottomImage) {
      Rect imageRect = isTopImage ? topImage.toRect() : bottomImage.toRect();
      normalizedPos = Vector2(
        (pos.x - imageRect.left) / imageRect.width,
        (pos.y - imageRect.top) / imageRect.height,
      );
    }
    return normalizedPos;
  }

  void displayHint() {
    for (int i = 0; i < circleOverlaysTop.length; i++) {
      if (circleOverlaysTop[i].opacity == 0.0) {
        double hintSize = getRandomDouble(15, 20);
        addHintTwinkle(circleOverlaysBottom[i].position + randomVector2(40),
            Vector2(hintSize, hintSize));
        addHintTwinkle(circleOverlaysTop[i].position + randomVector2(40),
            Vector2(hintSize, hintSize));
        break;
      }
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

    removeAllHintTwinkles();
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

  Future<void> onLevelCompleted() async {
    if (kDebugMode) {
      print('Level completed!');
    }
    await Future.delayed(const Duration(milliseconds: 700));
    overlays.add(levelCompleteOverlayIdentifier);
  }

  Future<void> onLevelFail() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (kDebugMode) {
      print('Level failed!');
    }
    overlays.add(gameOverOverlayIdentifier);
  }

  Future<void> nextLevel() async {
    await Future.delayed(const Duration(milliseconds: 500));

    gameState.currentLevelIndex++;
    if (gameState.currentLevelIndex >= levels.length) {
      gameState.currentLevelIndex = 0; // Looping back to first level
    }

    removeLastLevelImages();
    await loadLevel();
  }

  Future<void> resetLevel() async {
    await Future.delayed(const Duration(milliseconds: 500));

    removeLastLevelImages();
    await loadLevel();
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
    remove(topImageContainer);
    remove(bottomImageContainer);
    removeAll(stars);
  }

  void addHintTwinkle(Vector2 position, Vector2 size) {
    final hintTwinkle = HintTwinkle(
      hintSprite,
      size,
      position,
    );

    hintTwinkles.add(hintTwinkle);

    add(hintTwinkle);
    hintTwinkle.playEffects();
  }

  void removeAllHintTwinkles() {
    for (var hintTwinkle in hintTwinkles) {
      remove(hintTwinkle);
    }

    hintTwinkles.clear();
  }

  void hideAllHintTwinkles() {
    animateOpacity(hintTwinkles, 0, const Duration(milliseconds: 50));
  }

  void hideAllCircleOverlays() {
    animateOpacity(
        circleOverlaysTop.where((element) => element.hasBeenClicked).toList(),
        0,
        const Duration(milliseconds: 50));
    animateOpacity(
        circleOverlaysBottom
            .where((element) => element.hasBeenClicked)
            .toList(),
        0,
        const Duration(milliseconds: 50));
  }

  void hideAllImageOverlays() {
    hideAllCircleOverlays();
    hideAllHintTwinkles();
  }

  void showAllCircleOverlays() {
    animateOpacity(
        circleOverlaysTop.where((element) => element.hasBeenClicked).toList(),
        1,
        const Duration(milliseconds: 50));
    animateOpacity(
        circleOverlaysBottom
            .where((element) => element.hasBeenClicked)
            .toList(),
        1,
        const Duration(milliseconds: 50));
  }

  void showAllHintTwinkles() {
    animateOpacity(hintTwinkles, 1, const Duration(milliseconds: 50));
  }

  void showAllImageOverlays() {
    showAllCircleOverlays();
    showAllHintTwinkles();
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
