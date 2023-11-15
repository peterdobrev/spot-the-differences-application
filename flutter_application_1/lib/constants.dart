import 'dart:ui';

const String topImagePath_1 = 'vintage_car_in_woods_1.png';
const String bottomImagePath_1 = 'vintage_car_in_woods_2.png';
const String topImagePath_2 = 'animal_park_1.png';
const String bottomImagePath_2 = 'animal_park_2.png';
const String circleImagePath = 'circle.png';
const String wrongImagePath = 'wrong_tap.png';
const String heartImagePath = 'heart.png';
const String starImagePath = 'star.png';
const String vignetteImagePath = 'vignette_overlay.png';
const double aspectRatio = 1.5;
const double spaceBetweenImages = 20 / 100; // % of screen height
const int startingLives = 3;
const double heartsRatioToScreenWidth = 0.08;
const double starsRatioToScreenWidth = 0.11;
const int additionalPixelOffsetHearts = 10;
const double ratioOffsetHeartsScreenWidth = 0.08;
const double ratioOffsetHeartsScreenHeight = 0.05;
const double wrongTapSizeRatio = 0.08;
const Color backgroundColor = Color.fromARGB(255, 61, 61, 61);
const double lightenDelay = 1.0;
const double particlesLifecycle = 1.0;
const double fireworksInitialSpeed = 600;
const double fireworksDecelerationMultipler = -1;
