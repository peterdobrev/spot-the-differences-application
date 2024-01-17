import 'dart:ui';

// Image Paths
const String circleImagePath = 'circle.png';
const String wrongImagePath = 'wrong_tap.png';
const String heartImagePath = 'heart.png';
const String starImagePath = 'star.png';
const String hintImagePath = 'hint.png';
const String hintButtonImagePath = 'hint_button.png';
const String settingsImagePath = 'settings_icon.png';
const String vignetteImagePath = 'vignette_overlay.png';

// Level Image Paths
const List<String> topImagePaths = [
  'vintage_car_in_woods_1.png', // Top Image Path 1
  'animal_park_1.png', // Top Image Path 2
  'dancing_1.png', // Top Image Path 3
  'football_1.png', // Top Image Path 4
  'sportcars_1.png', // Top Image Path 5
  'tools_1.png', // Top Image Path 6
  'capybara_1.png', // Top Image Path 7
  'wild_1.png', // Top Image Path 8
];
const List<String> bottomImagePaths = [
  'vintage_car_in_woods_2.png', // Bottom Image Path 1
  'animal_park_2.png', // Bottom Image Path 2
  'dancing_2.png', // Bottom Image Path 3
  'football_2.png', // Bottom Image Path 4
  'sportcars_2.png', // Bottom Image Path 5
  'tools_2.png', // Bottom Image Path 6
  'capybara_2.png', // Bottom Image Path 7
  'wild_2.png', // Bottom Image Path 8
];

// Sound File Paths
const String levelCompleteSound = 'level_complete.mp3';
const String gameOverSound = 'level_fail.mp3';
const String wrongTapSound = 'drum_failure.mp3';
const String correctTapSound = 'ding.mp3';
const String hintSound = 'sparkle_notification.mp3';

// Game Settings
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

// Particle Settings
const double lightenDelay = 1.0;
const double particlesLifecycle = 1.0;
const double fireworksInitialSpeed = 600;
const double fireworksDecelerationMultipler = -1;

// Overlay Identifiers
const String mainMenuOverlayIdentifier = 'MainMenu';
const String levelCompleteOverlayIdentifier = 'LevelComplete';
const String gameOverOverlayIdentifier = 'GameOver';
const String settingsOverlayIdentifier = 'Settings';

// Colors
const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

// Zoom Settings
const int msDelayBetweenNewZoom = 20;
const double maxZoomLevel = 3.0;
const double minZoomLevel = 1.0;
