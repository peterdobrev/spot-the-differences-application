import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/utils/utils.dart';
import 'package:vibration/vibration.dart';

class WrongTap extends SpriteComponent {
  WrongTap(Sprite sprite, Vector2 position, Vector2 size)
      : super(
            sprite: sprite,
            position: position,
            size: size,
            anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

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

  Future<void> playWrongTapVibration() async {
    Vibration.vibrate(duration: 100, amplitude: 128);
  }

  void playWrongTapSound(double volumeLevel) {
    FlameAudio.play(wrongTapSound, volume: volumeLevel);
  }

  void playEffects(bool vibrationEnabled, double volumeLevel) {
    playWrongTapAnimations();
    if (vibrationEnabled) {
      playWrongTapVibration();
    }
    playWrongTapSound(volumeLevel);
  }
}
