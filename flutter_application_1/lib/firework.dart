import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/utils/utils.dart';

Particle fireworkParticle() {
  // A palette to paint over the "sky"
  final paints = [
    Colors.amber,
    Colors.amberAccent,
    Colors.red,
    Colors.redAccent,
    Colors.yellow,
    Colors.yellowAccent,
    // Adds a nice "lense" tint
    // to overall effect
    Colors.blue,
  ].map((color) => Paint()..color = color).toList();

  return Particle.generate(
    generator: (i) {
      final initialSpeed = randomVector2(fireworksInitialSpeed);
      final deceleration = initialSpeed * fireworksDecelerationMultipler;
      final gravity = Vector2(0, 40);

      return AcceleratedParticle(
        speed: initialSpeed,
        acceleration: deceleration + gravity,
        child: ComputedParticle(
          renderer: (canvas, particle) {
            final paint = randomElement(paints);
            // Override the color to dynamically update opacity
            paint.color = paint.color.withOpacity(1 - particle.progress);

            canvas.drawCircle(
              Offset.zero,
              // Closer to the end of lifespan particles
              // will turn into larger glaring circles
              Random().nextDouble() * particle.progress > .6
                  ? Random().nextDouble() * (50 * particle.progress)
                  : 2 + (3 * particle.progress),
              paint,
            );
          },
        ),
      );
    },
  );
}
