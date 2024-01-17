import 'package:flutter/material.dart';
import 'package:flutter_application_1/game_logic/differences_game.dart';
import 'package:flutter_application_1/utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  final DifferencesGame game;

  const SettingsScreen({super.key, required this.game});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
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
      child: _buildSettingsScreen(),
    );
  }

  Widget _buildSettingsScreen() {
    return Material(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildVolumeControl(),
            _buildVibrationControl(),
            _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Column(
      children: [
        const Text('Volume Control', style: TextStyle(color: Colors.white)),
        Slider(
          value: widget.game.volumeLevel,
          min: 0.0,
          max: 1.0,
          onChanged: (value) {
            setState(() {
              widget.game.volumeLevel = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildVibrationControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Vibrations', style: TextStyle(color: Colors.white)),
        Checkbox(
          value: widget.game.vibrationEnabled,
          onChanged: (bool? value) {
            setState(() {
              widget.game.vibrationEnabled = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      onPressed: () {
        widget.game.overlays.remove(settingsOverlayIdentifier);
      },
      child: const Text('Close', style: TextStyle(color: Colors.white)),
    );
  }
}
