import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class TipSystemComponent extends SpriteComponent {
  late final TextComponent _textComponent;
  late int _tipsCount;

  TipSystemComponent({
    required Sprite buttonSprite,
    required Vector2 position,
    required Vector2 size,
    required int tipsCount,
  })  : _tipsCount = tipsCount,
        super(
            sprite: buttonSprite,
            position: position,
            size: size,
            anchor: Anchor.center) {
    _textComponent = TextComponent(
      text: '$_tipsCount',
      textRenderer: TextPaint(
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontFamily: 'BubblegumSans')),
      position: Vector2(size.x - 5, 0 + 5),
      anchor: Anchor.center,
    );

    add(_textComponent);
  }

  bool requestTip() {
    if (_tipsCount > 0) {
      _useTip();
      return true;
    }
    _watchAd();
    return false;
  }

  void _useTip() {
    if (_tipsCount > 0) {
      _tipsCount--;
    }
    _updateTipCount();
    _playHintVibration();
  }

  void _watchAd() {
    // To implement later
    _tipsCount += 3;
    _updateTipCount();
  }

  void _updateTipCount() {
    _textComponent.text = _tipsCount == 0 ? "AD" : '$_tipsCount';
  }

  void _playHintVibration() {
    Vibration.vibrate(duration: 100, amplitude: 128);
  }

  // Public getter for tips count
  int get tipsCount => _tipsCount;
}
