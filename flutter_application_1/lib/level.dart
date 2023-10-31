import 'dart:ui';

class Level {
  final String topImagePath;
  final String bottomImagePath;
  final List<Rect> differences;

  Level(
      {required this.topImagePath,
      required this.bottomImagePath,
      required this.differences});
}
