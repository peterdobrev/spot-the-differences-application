import 'dart:ui';

import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/level.dart';

/// DONT FORGET TO MULTIPLY THE OFFSETS BY THE IMAGE SIZE
List<Level> levels = [
  Level(topImagePath: image1Path, bottomImagePath: image2Path, differences: [
    Rect.fromPoints(const Offset(0.1, 0.1), const Offset(0.3, 0.3)),
    Rect.fromPoints(const Offset(0.6, 0.6), const Offset(0.8, 0.8)),
  ]),
  Level(topImagePath: image2Path, bottomImagePath: image1Path, differences: [
    Rect.fromPoints(const Offset(0.1, 0.1), const Offset(0.3, 0.3)),
    Rect.fromPoints(const Offset(0.6, 0.6), const Offset(0.8, 0.8)),
  ]),
  // ... more levels
];
