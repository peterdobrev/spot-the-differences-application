import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/heart.dart';
import 'package:flutter_application_1/components/hint_twinkle.dart';
import 'package:flutter_application_1/components/overlay_circle.dart';
import 'package:flutter_application_1/components/star.dart';
import 'package:flutter_application_1/components/tip_system_component.dart';
import 'package:flutter_application_1/components/wrong_tap.dart';
import 'package:flutter_application_1/game_logic/levels_data.dart';
import 'package:flutter_application_1/layers/background_layer.dart';
import 'package:flutter_application_1/particles/firework.dart';
import 'package:flutter_application_1/utils/constants.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'game_state.dart';

class DifferencesGame extends FlameGame
    with MultiTouchTapDetector, ScaleDetector {
  GameState gameState = GameState();

  // Settings
  double volumeLevel = 0.5;
  bool vibrationEnabled = true;

  // Image positioning
  late double startingY;

  // Zooming
  bool isZooming = false;
  double imageZoom = 1.0;
  late Vector2 zoomPosition;
  late Vector2 originalSrcSize;
  late Vector2 originalSrcPosition;
  DateTime _lastScaleTime = DateTime.now();

  late Vector2 dragStart;

  // Images
  late SpriteComponent topImage; // This is the top image
  late SpriteComponent bottomImage; // This is the bottom image

  late PositionComponent
      topImageContainer; // This is the container that holds the top image
  late PositionComponent
      bottomImageContainer; // This is the container that holds the bottom image

  late PositionComponent
      topPositionalContainer; // This is the container that holds the top image container and the top image overlay circles and allows to move everything together
  late PositionComponent
      bottomPositionalContainer; // This is the container that holds the bottom image container and the bottom image overlay circles and allows to move everything together

  late BackgroundLayer vignetteOverlay;

  late Sprite wrongSprite;
  late Sprite heartSprite;
  late Sprite starSprite;
  late Sprite hintSprite;
  late Sprite circleSprite;

  late TipSystemComponent hintButton;
  late SpriteButtonComponent settingsButton;

  // Difference areas
  List<Rect> differenceAreas = [];
  List<OverlayCircle> circleOverlaysTop = []; // first image
  List<OverlayCircle> circleOverlaysBottom = []; //second image
  List<Star> stars = [];

  // Lives
  List<Heart> hearts = [];

  // Hints
  List<HintTwinkle> hintTwinkles = [];

  // -------------------------
  // SECTION: Initialization and Loading
  // -------------------------
  @override
  Future<void> onLoad() async {
    final vignette = await Sprite.load(vignetteImagePath);
    vignetteOverlay = BackgroundLayer(vignette, size);

    circleSprite = await Sprite.load(circleImagePath);
    heartSprite = await Sprite.load(heartImagePath);
    starSprite = await Sprite.load(starImagePath);
    wrongSprite = await Sprite.load(wrongImagePath);
    hintSprite = await Sprite.load(hintImagePath);

    final settingsSprite = await Sprite.load(settingsImagePath);
    final hintButtonSprite = await Sprite.load(hintButtonImagePath);

    settingsButton = initButton(
        settingsSprite,
        Vector2(size.x * heartsRatioToScreenWidth,
            size.x * heartsRatioToScreenWidth),
        Vector2(size.x - size.x * ratioOffsetHeartsScreenWidth,
            size.y * ratioOffsetHeartsScreenHeight));

    hintButton = TipSystemComponent(
        buttonSprite: hintButtonSprite,
        position: Vector2(size.x / 2, size.y - 60),
        size: Vector2(60, 60),
        tipsCount: gameState.tipsCount);

    add(settingsButton);
    add(hintButton);

    await FlameAudio.audioCache.loadAll([
      correctTapSound,
      wrongTapSound,
      levelCompleteSound,
      gameOverSound,
      hintSound
    ]);

    await loadLevel();
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

    startingY = (screenHeight - totalHeight) / 2;

    topPositionalContainer = ClipComponent.rectangle(
      position: Vector2(0, startingY), // Adjusted position
      size: Vector2(imageWidth, imageHeight),
      children: [
        topImageContainer = PositionComponent(
            size: Vector2(imageWidth, imageHeight),
            children: [
              topImage = SpriteComponent(
                  sprite: spriteTop, size: Vector2(imageWidth, imageHeight))
            ])
      ],
    );

    bottomPositionalContainer = ClipComponent.rectangle(
      position: Vector2(
          0,
          startingY +
              imageHeight +
              size.x * spaceBetweenImages), // Adjusted position
      size: Vector2(imageWidth, imageHeight),
      children: [
        bottomImageContainer = PositionComponent(
            size: Vector2(imageWidth, imageHeight),
            children: [
              bottomImage = SpriteComponent(
                  sprite: spriteBottom, size: Vector2(imageWidth, imageHeight))
            ])
      ],
    );

    add(topPositionalContainer);
    add(bottomPositionalContainer);

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
                ratioOffsetHeartsScreenHeight), // Equation is the gap between each heart
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

      circleTop.opacity = 0;
      circleBottom.opacity = 0;

      circleOverlaysTop.add(circleTop);
      circleOverlaysBottom.add(circleBottom);

      topImageContainer.add(circleTop);
      bottomImageContainer.add(circleBottom);
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

  // -------------------------
  // SECTION: Zooming and Panning
  // -------------------------
  bool shouldIgnoreScaleGesture() {
    // If less than 20 milliseconds has passed or if the game is over, ignore
    return DateTime.now().difference(_lastScaleTime).inMilliseconds <
            msDelayBetweenNewZoom ||
        gameState.remainingDifferences <= 0;
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    if (info.pointerCount > 1) {
      if (shouldIgnoreScaleGesture()) {
        return;
      }
      _lastScaleTime = DateTime.now(); // Update the last scale time

      isZooming = true;

      zoomPosition = info.raw.focalPoint.toVector2();

      if (isTapOnPositionalComponent(zoomPosition, bottomPositionalContainer)) {
        // Adjust the zoom position to be relative to the top image
        zoomPosition.y -= topPositionalContainer.position.y +
            size.x * spaceBetweenImages +
            startingY;
      } else if (!isTapOnPositionalComponent(zoomPosition,
          topPositionalContainer)) // If the tap is not on any image, ignore this cycle
      {
        isZooming = false;
        return;
      }
    } else if (info.pointerCount == 1) {
      dragStart = info.raw.focalPoint.toVector2();
      isZooming = false;
    }
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (shouldIgnoreScaleGesture()) {
      return;
    }

    // For Dragging (Moving the Zoomed Position)
    if (info.pointerCount == 1 && imageZoom > 1.0) {
      performDrag(info);
    }
    // For Pinch-to-Zoom
    else if (info.pointerCount > 1) {
      if (isZooming = false) {
        return;
      }
      performPinchToZoom(info);
    }

    // Update the last scale time
    _lastScaleTime = DateTime.now();
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    if (shouldIgnoreScaleGesture()) {
      return;
    }
    // Update the last scale time
    _lastScaleTime = DateTime.now();
  }

  void performDrag(ScaleUpdateInfo info) {
    Vector2 currentTouchPoint = info.raw.focalPoint.toVector2();
    Vector2 dragDelta = currentTouchPoint - dragStart;
    dragStart = currentTouchPoint; // Update dragStart for the next cycle

    Vector2 newPosition = calculateNewZoomPosition(
        topImageContainer.position + dragDelta,
        zoomPosition,
        imageZoom,
        imageZoom,
        topImageContainer.size,
        topPositionalContainer.size);

    updateImagePositions(newPosition);
  }

  void performPinchToZoom(ScaleUpdateInfo info) {
    double newZoom = max(minZoomLevel, min(maxZoomLevel, info.scale.global.y));

    Vector2 newPosition = calculateNewZoomPosition(
        topImageContainer.position,
        zoomPosition,
        imageZoom,
        newZoom,
        topImageContainer.size,
        topPositionalContainer.size);

    updateImageZoom(newZoom, newPosition);
  }

  void updateImagePositions(Vector2 newPosition) {
    topImageContainer.position = newPosition;
    bottomImageContainer.position = newPosition;
  }

  void updateImageZoom(double newZoom, Vector2 newPosition) {
    Vector2 imageScale = Vector2(newZoom, newZoom);
    topImageContainer.scale = imageScale;
    bottomImageContainer.scale = imageScale;

    updateImagePositions(newPosition);
    imageZoom = newZoom;
  }

  Future<void> resetZoom() async {
    isZooming = false;
    updateImagePositions(Vector2.zero());
    topImageContainer.scale = Vector2.all(1);
    bottomImageContainer.scale = Vector2.all(1);
  }

  // -------------------------
  // SECTION: Tap handling
  // -------------------------
  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    final tapPos = info.eventPosition.widget;

    if (gameState.lives > 0 && gameState.remainingDifferences > 0) {
      if (isTapOnAnyImage(tapPos)) {
        handleImageTap(tapPos);
      } else if (isTapOnPositionalComponent(tapPos, settingsButton)) {
        overlays.add(settingsOverlayIdentifier);
      } else if (isTapOnPositionalComponent(tapPos, hintButton)) {
        if (hintButton.requestTip()) {
          displayHint();
        }
      }
    }
  }

  bool isTapOnAnyImage(Vector2 tapPos) {
    return isTapOnPositionalComponent(tapPos, topPositionalContainer) ||
        isTapOnPositionalComponent(tapPos, bottomPositionalContainer);
  }

  void handleImageTap(Vector2 tapPos) {
    final isTopImage =
        isTapOnPositionalComponent(tapPos, topPositionalContainer);
    final isBottomImage =
        isTapOnPositionalComponent(tapPos, bottomPositionalContainer);

    if (!isTopImage && !isBottomImage) {
      return; // Early exit if tap is not on any image
    }

    Vector2 imageTapPos = getImageTapPosition(
        tapPos,
        isTopImage
            ? topPositionalContainer.toRect()
            : bottomPositionalContainer.toRect(),
        topImageContainer,
        imageZoom);
    bool foundDifference = checkForDifference(imageTapPos);

    if (foundDifference) {
      onDifferenceSpotted(tapPos);
    } else {
      onWrongTap(tapPos);
    }
  }

  bool checkForDifference(Vector2 imageTapPos) {
    bool foundDifference = false;
    bool hasBeenAlreadyFound = false;
    for (int i = 0; i < circleOverlaysTop.length; i++) {
      if (circleOverlaysTop[i].toRect().contains(imageTapPos.toOffset()) ||
          circleOverlaysBottom[i].toRect().contains(imageTapPos.toOffset())) {
        // Play animation on click

        if (circleOverlaysTop[i].hasBeenClicked() ||
            circleOverlaysBottom[i].hasBeenClicked()) {
          hasBeenAlreadyFound = true;
        } else {
          circleOverlaysTop[i].opacity = 1.0;
          circleOverlaysBottom[i].opacity = 1.0;
          foundDifference = true;
        }

        circleOverlaysTop[i].playScaleUpAnimation();
        circleOverlaysBottom[i].playScaleUpAnimation();

        if (foundDifference || hasBeenAlreadyFound) break;
      }
    }
    return foundDifference;
  }

  void onDifferenceSpotted(Vector2 tapPos) {
    if (gameState.remainingDifferences > 0) {
      gameState.remainingDifferences--;
      updateStars(tapPos);
      FlameAudio.play(correctTapSound, volume: volumeLevel);
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
    wrongTap.playEffects(vibrationEnabled, volumeLevel);
  }

  // This method could be used to calculate the position normalized position of the differences on images
  Vector2 getNormalizedImagePos(Vector2 pos) {
    bool isTopImage = topPositionalContainer.toRect().contains(pos.toOffset());
    bool isBottomImage =
        bottomPositionalContainer.toRect().contains(pos.toOffset());

    Vector2 normalizedPos = Vector2.zero();
    if (isTopImage || isBottomImage) {
      Rect imageRect = isTopImage
          ? topImageContainer.toRect()
          : bottomImageContainer.toRect();
      normalizedPos = Vector2(
        (pos.x - imageRect.left) / imageRect.width,
        (pos.y - imageRect.top) / imageRect.height,
      );
    }
    return normalizedPos;
  }

  // -------------------------
  // SECTION: Hints
  // -------------------------
  void displayHint() {
    for (int i = 0; i < circleOverlaysTop.length; i++) {
      if (circleOverlaysTop[i].opacity == 0.0) {
        double hintSize = getRandomDouble(15, 20);
        addHintTwinkle(
            circleOverlaysTop[i].position +
                randomVector2(
                    40), // Adding a random offset from the center of the circle
            Vector2(hintSize, hintSize),
            topImageContainer);
        addHintTwinkle(
            circleOverlaysBottom[i].position +
                randomVector2(
                    40), // Adding a random offset from the center of the circle
            Vector2(hintSize, hintSize),
            bottomImageContainer);

        break;
      }
    }

    FlameAudio.play(hintSound, volume: volumeLevel);
  }

  void addHintTwinkle(
      Vector2 position, Vector2 size, PositionComponent parent) {
    final hintTwinkle = HintTwinkle(
      hintSprite,
      size,
      position,
    );

    hintTwinkles.add(hintTwinkle);

    parent.add(hintTwinkle);
    hintTwinkle.playEffects(volumeLevel);
  }

  void removeAllHintTwinkles() {
    for (var hintTwinkle in hintTwinkles) {
      if (topImageContainer.contains(hintTwinkle)) {
        topImageContainer.remove(hintTwinkle);
      } else if (bottomImageContainer.contains(hintTwinkle)) {
        bottomImageContainer.remove(hintTwinkle);
      }
    }

    hintTwinkles.clear();
  }

  // -------------------------
  // SECTION: Game Over and Level Complete Event Handlers
  // -------------------------
  Future<void> onLevelCompleted() async {
    if (kDebugMode) {
      print('Level completed!');
    }
    imageZoom = 1.0;

    await Future.delayed(const Duration(milliseconds: 700));
    overlays.add(levelCompleteOverlayIdentifier);
  }

  Future<void> onLevelFail() async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (kDebugMode) {
      print('Level failed!');
    }

    imageZoom = 1.0;
    overlays.add(gameOverOverlayIdentifier);
  }

  Future<void> nextLevel() async {
    await Future.delayed(const Duration(milliseconds: 500));

    gameState.currentLevelIndex++;
    if (gameState.currentLevelIndex >= levels.length) {
      gameState.currentLevelIndex = 0; // Looping back to first level
    }

    imageZoom = 1.0;
    removeLastLevelImages();
    await loadLevel();
  }

  Future<void> resetLevel() async {
    await Future.delayed(const Duration(milliseconds: 500));

    resetZoom();
    removeLastLevelImages();
    await loadLevel();
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
    remove(topPositionalContainer);
    remove(bottomPositionalContainer);
    removeAll(stars);
  }

  // -------------------------
  // SECTION: Update and Render
  // -------------------------
  void updateHearts() {
    if (gameState.lives >= 0 && gameState.lives < hearts.length) {
      hearts[gameState.lives].playDarkenAnimations();
    }
  }

  void updateStars(Vector2 tapPos) {
    if (gameState.remainingDifferences >= 0 &&
        gameState.remainingDifferences < hearts.length) {
      stars[gameState.remainingDifferences].playLightenAnimation();
      stars[gameState.remainingDifferences].playScaleUpAnimation();
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
