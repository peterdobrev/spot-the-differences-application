import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class TipSystemComponent extends SpriteComponent {
  late SpriteComponent buttonComponent;
  late TextComponent textComponent;
  late SpriteComponent adIconComponent;

  late int tipsCount;

  TipSystemComponent({
    required Sprite buttonSprite,
    //required this.adIconSprite,
    required Vector2 position,
    required Vector2 size,
    required this.tipsCount,
  }) : super(
            sprite: buttonSprite,
            position: position,
            size: size,
            anchor: Anchor.center) {
    textComponent = TextComponent(
      text: '$tipsCount',
      textRenderer: TextPaint(
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontFamily: 'BubblegumSans')),
      position: Vector2(size.x - 5,
          0 + 5), // Top right corner with some offset towards the center
      anchor: Anchor.center,
    );

    // Add children
    add(textComponent);
  }

  bool requestTip() {
    if (tipsCount > 0) {
      useTip();
      return true;
    }
    watchAd();
    return false;
  }

  void useTip() {
    if (tipsCount > 0) {
      tipsCount--;
    }
    updateTipCount();
    playHintVibration();
  }

  void watchAd() {
    // To implement later
    tipsCount += 3;
    updateTipCount();
  }

  // Call this method to update the tip count
  void updateTipCount() {
    textComponent.text = '$tipsCount';

    if (tipsCount == 0) {
      textComponent.text = "AD";
    } else {
      textComponent.text = '$tipsCount';
    }
  }

  void playHintVibration() {
    Vibration.vibrate(duration: 100, amplitude: 128);
  }
}
