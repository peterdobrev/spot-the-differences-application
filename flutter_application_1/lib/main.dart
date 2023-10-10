import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Spot the Differences",
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Rect? highlightRect;

  final Rect differenceArea = Rect.fromPoints(
    const Offset(0.0, 0.0),
    const Offset(1.0, 1.0),
  );

  void onTap(TapUpDetails details, BuildContext context, bool isRightImage) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset =
        renderBox.localToGlobal(Offset.zero); // Get the global position

    // Calculate the local position
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    // Adjust the local position based on the widget's global position
    final adjustedLocalPosition = localPosition - offset;

    print('Global Offset: $offset');
    print('Original Local Position: $localPosition');
    print('Adjusted Local Position: $adjustedLocalPosition');

    // Continue your existing logic, e.g., calculating relative coordinates
    final size = renderBox.size;
    var dx = adjustedLocalPosition.dx / size.width;
    final dy = adjustedLocalPosition.dy / size.height;

    if (isRightImage) {
      dx -= 0.5;
    }

    print(
        'Tapped at: (${adjustedLocalPosition.dx};${adjustedLocalPosition.dy})');
    print('Tapped at: ($dx;$dy)');

    // Check if the tap is within the area of difference
    if (differenceArea.contains(Offset(dx, dy))) {
      // Assuming highlightRect is a state variable
      setState(() {
        highlightRect = Rect.fromPoints(
          Offset(adjustedLocalPosition.dx - 20, adjustedLocalPosition.dy - 20),
          Offset(adjustedLocalPosition.dx + 20, adjustedLocalPosition.dy + 20),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          buildImage(context, 'assets/vintage_car_in_woods_1.png', false),
          buildImage(context, 'assets/vintage_car_in_woods_2.png', true),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context, String imageName, bool isRightImage) {
    return GestureDetector(
      onTapUp: (details) => onTap(details, context, isRightImage),
      child: Stack(
        children: [
          Image.asset(
            imageName,
            fit: BoxFit.cover, // This will cover the entire available space
          ),
          if (highlightRect != null)
            Positioned(
              left: highlightRect!.left,
              top: highlightRect!.top,
              child: Container(
                width: highlightRect!.width,
                height: highlightRect!.height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
