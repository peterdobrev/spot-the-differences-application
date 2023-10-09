import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Changed super.key to this

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Spot the Differences",
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  // Define the area of difference (in relative coordinates between 0 and 1)
  final Rect differenceArea = Rect.fromPoints(
    const Offset(0.2, 0.4), // top-left corner
    const Offset(0.5, 0.9), // bottom-right corner
  );

  void onTap(TapUpDetails details, BuildContext context, String imageName,
      bool isRightImage) {
    // Get the size of the image widget
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // Convert tap location to relative coordinates
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    var dx = localPosition.dx / size.width;
    final dy = localPosition.dy / size.height;

    // Adjust dx for the right image
    if (isRightImage) {
      dx -= 0.5;
    }

    print('Tapped in $imageName!');
    print('Tapped at: ${Offset(dx, dy)}');

    // Check if the tap is within the area of difference
    if (differenceArea.contains(Offset(dx, dy))) {
      print('Difference spotted in $imageName!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildImage(context, 'assets/vintage_car_in_woods_1.png', false),
            buildImage(context, 'assets/vintage_car_in_woods_2.png', true),
          ],
        ),
      ),
    );
  }

  Widget buildImage(BuildContext context, String imageName, bool isRightImage) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTapUp: (details) =>
              onTap(details, context, imageName, isRightImage),
          child: Image.asset(imageName),
        ),
      ),
    );
  }
}
