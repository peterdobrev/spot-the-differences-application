import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_application_1/game_logic/differences_game.dart';
import 'package:flutter_application_1/utils/constants.dart';

class GameOver extends StatefulWidget {
  final DifferencesGame game;

  const GameOver({super.key, required this.game});

  @override
  // ignore: library_private_types_in_public_api
  _GameOverState createState() => _GameOverState();
}

class _GameOverState extends State<GameOver>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    FlameAudio.play(gameOverSound, volume: 0.6 * widget.game.volumeLevel);
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _animation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.05)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: _buildGameOverDialog(),
    );
  }

  Widget _buildGameOverDialog() {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 200,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              _buildPlayAgainButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayAgainButton() {
    return SizedBox(
      width: 200,
      height: 75,
      child: ElevatedButton(
        onPressed: () {
          widget.game.resetLevel();
          widget.game.overlays.remove(gameOverOverlayIdentifier);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: whiteTextColor,
        ),
        child: const Text(
          'Play Again',
          style: TextStyle(
            fontSize: 28.0,
            color: blackTextColor,
          ),
        ),
      ),
    );
  }
}
