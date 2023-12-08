import 'dart:math';
import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

double getRandomDouble(double min, double max) {
  var random = Random();
  return min + random.nextDouble() * (max - min);
}

Vector2 getRandomScreenPosition(Vector2 screenSize) {
  var random = Random();
  return Vector2(
    random.nextDouble() * screenSize.x,
    random.nextDouble() * screenSize.y,
  );
}

int getRandomInt(int min, int max) {
  var random = Random();
  return min + random.nextInt(max - min);
}

Color randomMaterialColor() {
  var random = Random();
  return Colors.primaries[random.nextInt(Colors.primaries.length)];
}

Vector2 randomVector2(double multiplier) {
  return (Vector2.random() - Vector2.random())
    ..multiply(Vector2(multiplier, multiplier));
}

T randomElement<T>(List<T> list) {
  var random = Random();
  return list[random.nextInt(list.length)];
}

bool isTapOnImage(Vector2 tapPos, SpriteComponent image) {
  return image.toRect().contains(tapPos.toOffset());
}

bool isTapOnButton(Vector2 tapPos, SpriteButtonComponent button) {
  return button.toRect().contains(tapPos.toOffset());
}

Vector2 lerpVector2(Vector2 a, Vector2 b, double t) {
  return Vector2(
    a.x + (b.x - a.x) * t,
    a.y + (b.y - a.y) * t,
  );
}

void animateOpacity(
    List<dynamic> items, double targetOpacity, Duration duration) {
  if (items.isEmpty) {
    return;
  }
  const int totalSteps = 10;
  final double stepSize = (targetOpacity - items.first.opacity) / totalSteps;
  final Duration stepDuration = duration ~/ totalSteps;

  void step(int currentStep) {
    if (currentStep >= totalSteps) {
      return;
    }

    for (var item in items) {
      item.opacity = (item.opacity + stepSize)
          .clamp(0.0, 1.0); // Ensures opacity stays within 0 to 1
    }

    Future.delayed(stepDuration, () => step(currentStep + 1));
  }

  step(0);
}
