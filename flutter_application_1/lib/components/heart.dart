import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class Heart extends SpriteComponent {
  Heart(Sprite sprite, Vector2 size, Vector2 position)
      : super(
            sprite: sprite,
            position: position,
            size: size,
            anchor: Anchor.center);

  void playDarkenAnimations() {
    SequenceEffect scaleEffect = SequenceEffect([
      ScaleEffect.to(Vector2.all(1.1), EffectController(duration: 0.1)),
      ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.1))
    ]);
    SequenceEffect colorEffect = SequenceEffect([
      ColorEffect(
        const Color.fromARGB(255, 129, 0, 0),
        EffectController(duration: 0.1),
        opacityFrom: 0.5,
        opacityTo: 0,
      ),
      ColorEffect(
        const Color.fromARGB(255, 114, 114, 114),
        EffectController(duration: 0.1),
        opacityFrom: 0,
        opacityTo: 1,
      )
    ]);

    SequenceEffect rotateEffect = SequenceEffect([
      RotateEffect.to(7 * pi / 180, EffectController(duration: 0.05)),
      RotateEffect.to(-4 * pi / 180, EffectController(duration: 0.05)),
      RotateEffect.to(2 * pi / 180, EffectController(duration: 0.05)),
      RotateEffect.to(0, EffectController(duration: 0.05))
    ]);

    add(scaleEffect);
    add(colorEffect);
    add(rotateEffect);
  }
}
