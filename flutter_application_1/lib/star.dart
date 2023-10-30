import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';

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
        const Offset(0.0, 1),
        EffectController(duration: 0.1),
      ),
    );
    return super.onLoad();
  }

  void lighten() {
    add(
      ColorEffect(
        const Color.fromARGB(0, 255, 230, 0),
        const Offset(0.0, 0),
        EffectController(duration: 0.5),
      ),
    );
  }
}
