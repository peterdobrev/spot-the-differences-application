import 'package:flutter/material.dart';
import 'package:flutter_application_1/game_logic/differences_game.dart';
import 'package:flutter_application_1/utils/constants.dart';

class MainMenu extends StatefulWidget {
  final DifferencesGame game;

  const MainMenu({super.key, required this.game});

  @override
  // ignore: library_private_types_in_public_api
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

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
      child: _buildMainMenu(),
    );
  }

  Widget _buildMainMenu() {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 250,
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
              _buildTitleText(),
              const SizedBox(height: 40),
              _buildPlayButton(),
              const SizedBox(height: 20),
              _buildInstructionsText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return const Text(
      'Spot the Differences',
      style: TextStyle(
        color: whiteTextColor,
        fontSize: 24,
      ),
    );
  }

  Widget _buildPlayButton() {
    return SizedBox(
      width: 200,
      height: 75,
      child: ElevatedButton(
        onPressed: () {
          widget.game.overlays.remove(mainMenuOverlayIdentifier);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: whiteTextColor,
        ),
        child: const Text(
          'Play',
          style: TextStyle(
            fontSize: 40.0,
            color: blackTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsText() {
    return const Text(
      '''Tap on the images where you see a difference!''',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: whiteTextColor,
        fontSize: 15,
      ),
    );
  }
}
