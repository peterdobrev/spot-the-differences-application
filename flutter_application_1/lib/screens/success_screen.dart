import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Congratulations!'),
      ),
      body: const Center(
        child: Text(
          'You spotted all the differences!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
