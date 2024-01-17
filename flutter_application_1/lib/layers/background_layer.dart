import 'package:flame/components.dart';
import 'package:flame/layers.dart';

class BackgroundLayer extends PreRenderedLayer {
  final Sprite _sprite;
  final Vector2 _size;

  BackgroundLayer(this._sprite, this._size);

  @override
  void drawLayer() {
    _sprite.render(
      canvas,
      position: Vector2.zero(),
      size: _size,
    );
  }
}
