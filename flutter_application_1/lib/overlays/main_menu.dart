import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/differences_game.dart';

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
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return ScaleTransition(
        scale: _animation,
        child: Material(
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
                  const Text(
                    'Spot the Differences',
                    style: TextStyle(
                      color: whiteTextColor,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
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
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '''Tap on the images where you see a difference!''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: whiteTextColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
