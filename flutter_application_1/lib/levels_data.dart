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
  Level(
      topImagePath: topImagePath_3,
      bottomImagePath: bottomImagePath_3,
      differences: [
        Rect.fromPoints(const Offset(0.55, 0.9), const Offset(0.75, 1.1)),
        Rect.fromPoints(const Offset(0.3, 0.1), const Offset(0.5, 0.3)),
      ]),
  Level(
      topImagePath: topImagePath_4,
      bottomImagePath: bottomImagePath_4,
      differences: [
        Rect.fromPoints(const Offset(0.66, 0.14), const Offset(0.86, 0.34)),
      ]),
  Level(
      topImagePath: topImagePath_5,
      bottomImagePath: bottomImagePath_5,
      differences: [
        Rect.fromPoints(const Offset(0.35, 0.55), const Offset(0.55, 0.75)),
        Rect.fromPoints(const Offset(0.95, 0.27), const Offset(1.15, 0.47)),
      ]),
  Level(
      topImagePath: topImagePath_6,
      bottomImagePath: bottomImagePath_6,
      differences: [
        Rect.fromPoints(const Offset(0.3, 0.3), const Offset(0.5, 0.5)),
        Rect.fromPoints(const Offset(0.55, 0.35), const Offset(0.8, 0.6)),
        Rect.fromPoints(const Offset(0.17, 0.2), const Offset(.37, 0.4)),
      ]),
  Level(
      topImagePath: topImagePath_7,
      bottomImagePath: bottomImagePath_7,
      differences: [
        Rect.fromPoints(const Offset(0.2, 0.87), const Offset(0.5, 1.17)),
      ]),
  Level(
      topImagePath: topImagePath_8,
      bottomImagePath: bottomImagePath_8,
      differences: [
        Rect.fromPoints(const Offset(0.77, 0.84), const Offset(0.97, 1.04)),
        Rect.fromPoints(const Offset(0.41, 0.86), const Offset(0.61, 1.06)),
      ]),
  // ... more levels
];
