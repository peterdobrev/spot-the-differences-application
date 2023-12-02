import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_application_1/constants.dart';

class HintTwinkle extends SpriteComponent {
  HintTwinkle(Sprite sprite, Vector2 size, Vector2 position)
      : super(
            sprite: sprite,
            position: position,
            size: size,
            anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  void playHintAnimations() {
    opacity = 0;

    OpacityEffect opacityFadeInEffect =
        OpacityEffect.fadeIn(EffectController(duration: .3));

    SequenceEffect scaleEffect = SequenceEffect([
      ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.001)),
      ScaleEffect.to(Vector2.all(1.2), EffectController(duration: 0.4)),
      ScaleEffect.to(Vector2.all(1), EffectController(duration: 0.4))
    ], infinite: true);

    add(opacityFadeInEffect);
    add(scaleEffect);
  }

  void playHintSound() {
    FlameAudio.play(wrongTapSound);
  }

  void playEffects() {
    playHintAnimations();
    playHintSound();
  }
}
