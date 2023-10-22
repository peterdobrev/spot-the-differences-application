import 'package:flutter/material.dart';

class QuestionMarksWidget extends StatelessWidget {
  final int count;

  const QuestionMarksWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors
                    .lightBlue, // Choose the color of your circle outline here
                width: 2.0, // Choose the width of your circle outline here
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(
                Icons.question_mark_outlined,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
