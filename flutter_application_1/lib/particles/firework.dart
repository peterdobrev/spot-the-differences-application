import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/constants.dart';
import 'package:flutter_application_1/utils/utils.dart';

/// Generates a firework particle effect.
Particle fireworkParticle() {
  // Define constants for magic numbers
  const double gravityValue = 40;
  const double maxGlareRadius = 50;
  const double baseCircleSize = 2;
  const double maxCircleSize = 3;
  const double glareThreshold = 0.6;

  // A palette to paint over the "sky"
  final paints = [
    Colors.amber,
    Colors.amberAccent,
    Colors.red,
    Colors.redAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.blue, // Adds a nice "lense" tint to overall effect
  ].map((color) => Paint()..color = color).toList();

  final random = Random(); // Single Random instance

  return Particle.generate(
    generator: (i) {
      final initialSpeed = randomVector2(fireworksInitialSpeed);
      final deceleration = initialSpeed * fireworksDecelerationMultipler;
      final gravity = Vector2(0, gravityValue);

      return AcceleratedParticle(
        speed: initialSpeed,
        acceleration: deceleration + gravity,
        child: ComputedParticle(
          renderer: (canvas, particle) {
            final paint = randomElement(paints);
            paint.color = paint.color.withOpacity(1 - particle.progress);

            canvas.drawCircle(
              Offset.zero,
              random.nextDouble() * particle.progress > glareThreshold
                  ? random.nextDouble() * (maxGlareRadius * particle.progress)
                  : baseCircleSize + (maxCircleSize * particle.progress),
              paint,
            );
          },
        ),
      );
    },
  );
}
