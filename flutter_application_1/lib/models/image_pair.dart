import 'package:flutter/material.dart';

class ImagePair {
  final String topImage;
  final String bottomImage;
  final List<Rect> differenceAreas;

  ImagePair({
    required this.topImage,
    required this.bottomImage,
    required this.differenceAreas,
  });
}
