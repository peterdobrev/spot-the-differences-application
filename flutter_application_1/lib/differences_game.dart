import 'package:flame/components.dart';
import 'package:flame/game.dart';

class DifferencesGame extends FlameGame {
  late SpriteComponent image1;
  late SpriteComponent image2;

  @override
  Future<void> onLoad() async {
    final sprite1 = await Sprite.load('vintage_car_in_woods_1.png');
    final sprite2 = await Sprite.load('vintage_car_in_woods_2.png');

    final screenHalfHeight = size.y / 2;
    final screenWidth = size.x;

    // Calculate new dimensions while keeping aspect ratio for the first image
    final aspectRatio1 = sprite1.srcSize.x / sprite1.srcSize.y;
    final imageWidth = screenWidth;
    final imageHeight = imageWidth / aspectRatio1;

    image1 = SpriteComponent(
      sprite: sprite1,
      position: Vector2(
          (size.x - imageWidth) / 2, 0), // Center the image horizontally
      size: Vector2(imageWidth, imageHeight),
    );

    image2 = SpriteComponent(
      sprite: sprite2,
      position: Vector2((size.x - imageWidth) / 2,
          screenHalfHeight), // Center the image horizontally
      size: Vector2(imageWidth, imageHeight),
    );

    add(image1);
    add(image2);
  }
}
