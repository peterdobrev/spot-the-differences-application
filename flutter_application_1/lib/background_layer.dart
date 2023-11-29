import 'package:flame/components.dart';
import 'package:flame/layers.dart';

class BackgroundLayer extends PreRenderedLayer {
  final Sprite sprite;
  final Vector2 size;

  BackgroundLayer(this.sprite, this.size);

  @override
  void drawLayer() {
    sprite.render(
      canvas,
      position: Vector2.zero(),
      size: size,
    );
  }
}
