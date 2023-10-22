import 'package:flutter/material.dart';

class HeartsWidget extends StatelessWidget {
  final int lives;
  final int startingLives;

  const HeartsWidget(
      {super.key, required this.startingLives, required this.lives});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        startingLives,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(
            Icons.favorite,
            color: index < lives ? Colors.red : Colors.grey,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}
