import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class Star extends SpriteComponent {
  Star(Sprite sprite, Vector2 size, Vector2 position)
      : super(
            sprite: sprite,
            position: position,
            size: size,
            anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() {
    add(
      ColorEffect(
        const Color.fromARGB(255, 114, 114, 114),
        EffectController(duration: 0.1),
      ),
    );
    return super.onLoad();
  }

  void playLightenAnimation() {
    add(
      ColorEffect(
        const Color.fromARGB(0, 255, 230, 0),
        EffectController(duration: 0.5),
        opacityFrom: 0.3,
        opacityTo: 0,
      ),
    );
  }

  void playScaleUpAnimation() {
    SequenceEffect effect = SequenceEffect([
      ScaleEffect.to(Vector2.all(0.7), EffectController(duration: 0.01)),
      ScaleEffect.to(Vector2.all(1.1), EffectController(duration: 0.15)),
      ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.15))
    ]);
    add(effect);
  }
}
