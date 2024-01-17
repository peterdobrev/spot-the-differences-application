import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/game_logic/differences_game.dart';
import 'package:flutter_application_1/utils/constants.dart';

class LevelComplete extends StatefulWidget {
  final DifferencesGame game;

  const LevelComplete({super.key, required this.game});

  @override
  // ignore: library_private_types_in_public_api
  _LevelCompleteState createState() => _LevelCompleteState();
}

class _LevelCompleteState extends State<LevelComplete>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    FlameAudio.play(levelCompleteSound, volume: widget.game.volumeLevel);
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
      child: _buildLevelCompleteDialog(),
    );
  }

  Widget _buildLevelCompleteDialog() {
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
              _buildLevelCompleteText(),
              const SizedBox(height: 40),
              _buildNextLevelButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCompleteText() {
    return Text(
      'Level ${widget.game.gameState.currentLevelIndex + 1} Complete!',
      style: const TextStyle(
        color: whiteTextColor,
        fontSize: 24,
      ),
    );
  }

  Widget _buildNextLevelButton() {
    return SizedBox(
      width: 200,
      height: 75,
      child: ElevatedButton(
        onPressed: () {
          widget.game.nextLevel();
          widget.game.overlays.remove(levelCompleteOverlayIdentifier);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: whiteTextColor,
        ),
        child: const Text(
          'Next Level',
          style: TextStyle(
            fontSize: 28.0,
            color: blackTextColor,
          ),
        ),
      ),
    );
  }
}
