import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter_application_1/utils.dart';

class WrongTap extends SpriteComponent {
  WrongTap(Sprite sprite, Vector2 position, Vector2 size)
      : super(
            sprite: sprite,
            position: position,
            size: size,
            anchor: Anchor.center);

  void playWrongTapAnimations() {
    opacity = 1;

    SequenceEffect scaleEffect = SequenceEffect([
      ScaleEffect.to(Vector2.all(0.2), EffectController(duration: 0.001)),
      ScaleEffect.to(Vector2.all(1.2), EffectController(duration: 0.15)),
      ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.1))
    ]);

    SequenceEffect rotateEffect = SequenceEffect([
      RotateEffect.to(
          getRandomInt(-15, 15) * pi / 180, EffectController(duration: 0.001)),
      RotateEffect.to(
          getRandomInt(-15, 15) * pi / 180, EffectController(duration: 0.25)),
    ]);

    OpacityEffect opacityEffect =
        OpacityEffect.fadeOut(EffectController(duration: 0.3, startDelay: 0.7));

    add(scaleEffect);
    add(rotateEffect);
    add(opacityEffect);
  }
}
