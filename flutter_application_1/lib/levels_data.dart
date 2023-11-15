import 'dart:ui';

import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/level.dart';

/// DONT FORGET TO MULTIPLY THE OFFSETS BY THE IMAGE SIZE
List<Level> levels = [
  Level(
      topImagePath: topImagePath_1,
      bottomImagePath: bottomImagePath_1,
      differences: [
        Rect.fromPoints(const Offset(0.8, 0.72), const Offset(1, 0.92)),
      ]),
  Level(
      topImagePath: topImagePath_2,
      bottomImagePath: bottomImagePath_2,
      differences: [
        Rect.fromPoints(const Offset(0.42, 0.6), const Offset(0.62, 0.8)),
        Rect.fromPoints(const Offset(0.75, 0.8), const Offset(0.95, 1)),
      ]),
  // ... more levels
];
