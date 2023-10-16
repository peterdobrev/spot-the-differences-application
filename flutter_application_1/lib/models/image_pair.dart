import 'package:flutter/material.dart';

class ImagePair {
  final String leftImage;
  final String rightImage;
  final List<Rect> differenceAreas;

  ImagePair({
    required this.leftImage,
    required this.rightImage,
    required this.differenceAreas,
  });
}
