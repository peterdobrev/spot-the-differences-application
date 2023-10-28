import 'dart:ui';

const String image1Path = 'vintage_car_in_woods_1.png';
const String image2Path = 'vintage_car_in_woods_2.png';
const String circleImagePath = 'circle.png';
const String heartImagePath = 'heart.png';
const String vignetteImagePath = 'vignette_overlay.png';
const double aspectRatio = 1.5;
const double spaceBetweenImages = 20 / 100; // % of screen height
const int startingLives = 3;
const double heartsRatioToScreenWidth = 0.08;
const int additionalPixelOffsetHearts = 10;
const double ratioOffsetHeartsScreenWidth = 0.06;
const double ratioOffsetHeartsScreenHeight = 0.04;
const Color backgroundColor = Color.fromARGB(255, 61, 61, 61);