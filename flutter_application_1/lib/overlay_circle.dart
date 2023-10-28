import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class OverlayCircle extends SpriteComponent {
  OverlayCircle(Sprite sprite, Vector2 position, Vector2 size)
      : super(
            sprite: sprite,
            position: position,
            size: size,
            anchor: Anchor.center);

  void scaleUp() {
    SequenceEffect effect = SequenceEffect([
      ScaleEffect.to(Vector2.all(0.7), EffectController(duration: 0.01)),
      ScaleEffect.to(Vector2.all(1.1), EffectController(duration: 0.1)),
      ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.1))
    ]);
    add(effect);
  }
}
