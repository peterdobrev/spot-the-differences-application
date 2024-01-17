import 'dart:math';
import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

final _random = Random(); // Single Random instance for the entire utils class

double getRandomDouble(double min, double max) {
  return min + _random.nextDouble() * (max - min);
}

Vector2 getRandomScreenPosition(Vector2 screenSize) {
  return Vector2(
    _random.nextDouble() * screenSize.x,
    _random.nextDouble() * screenSize.y,
  );
}

int getRandomInt(int min, int max) {
  return min + _random.nextInt(max - min);
}

Color randomMaterialColor() {
  return Colors.primaries[_random.nextInt(Colors.primaries.length)];
}

Vector2 randomVector2(double multiplier) {
  return (Vector2.random() - Vector2.random())
    ..multiply(Vector2(multiplier, multiplier));
}

T randomElement<T>(List<T> list) {
  return list[_random.nextInt(list.length)];
}

bool isTapOnPositionalComponent(Vector2 tapPos, PositionComponent image) {
  return image.toRect().contains(tapPos.toOffset());
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

Vector2 calculateNewZoomPosition(Vector2 currentPosition, Vector2 focalPoint,
    double oldZoom, double newZoom, Vector2 imageSize, Vector2 containerSize) {
  // Calculate the new position of the top left corner of the image
  Vector2 relativeFocalPoint = focalPoint - currentPosition;

  // Calculate the movement of the image due to scaling (since it scales from the top left corner)
  Vector2 movementDueToScaling =
      (relativeFocalPoint * newZoom / oldZoom) - relativeFocalPoint;
  Vector2 newPosition = currentPosition - movementDueToScaling;

  // Constraints for the new position so that the image doesn't go out of bounds
  double maxX = max(0, (imageSize.x * newZoom) - containerSize.x);
  double maxY = max(0, (imageSize.y * newZoom) - containerSize.y);

  // Adjust position to ensure it doesn't exceed the bounds
  newPosition.x = min(
      max(newPosition.x, -maxX), 0); // Ensure image doesn't move too far left
  newPosition.y =
      min(max(newPosition.y, -maxY), 0); // Ensure image doesn't move too far up

  return newPosition;
}

SpriteButtonComponent initButton(
    Sprite sprite, Vector2 size, Vector2 position) {
  SpriteButtonComponent button = SpriteButtonComponent(
      button: sprite,
      buttonDown: sprite,
      size: size,
      position: position,
      anchor: Anchor.center);

  return button;
}

Vector2 getImageTapPosition(Vector2 tapPos, Rect imageRect,
    PositionComponent topImageContainer, double imageZoom) {
  return Vector2(
    (tapPos.x - imageRect.left - topImageContainer.x) / imageZoom,
    (tapPos.y - imageRect.top - topImageContainer.y) / imageZoom,
  );
}
