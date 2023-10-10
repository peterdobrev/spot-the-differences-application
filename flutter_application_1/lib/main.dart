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
    var adjustedLocalPosition = localPosition - offset;

    final size = renderBox.size;
    var dx = adjustedLocalPosition.dx / size.width;
    final dy = adjustedLocalPosition.dy / size.height;

    var x = adjustedLocalPosition.dx;
    final y = adjustedLocalPosition.dy;

    if (isRightImage) {
      dx -= 0.5;
      x -= size.width / 2;
    }

    if (differenceArea.contains(Offset(dx, dy))) {
      setState(() {
        highlightRect = Rect.fromPoints(
          Offset(x - 20, y - 20),
          Offset(x + 20, y + 20),
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
    return Expanded(
      child: GestureDetector(
        onTapUp: (details) => onTap(details, context, isRightImage),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Now you have the constraints
            print(
                'Max Width: ${constraints.maxWidth}, Max Height: ${constraints.maxHeight}');
            return Stack(
              children: [
                Image.asset(
                  imageName,
                  fit: BoxFit
                      .cover, // This will cover the entire available space
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
            );
          },
        ),
      ),
    );
  }
}
