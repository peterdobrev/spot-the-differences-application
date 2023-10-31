import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

double getRandomDouble(double min, double max) {
  var random = Random();
  return min + random.nextDouble() * (max - min);
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
