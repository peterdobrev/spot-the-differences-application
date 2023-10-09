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
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Rect? highlightRect;

  final Rect differenceArea = Rect.fromPoints(
    const Offset(0.1, 0.1),
    const Offset(0.8, 0.9),
  );

  void onTap(TapUpDetails details, BuildContext context, bool isRightImage) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final localPosition = renderBox.globalToLocal(details.globalPosition);
    var dx = localPosition.dx / size.width;
    final dy = localPosition.dy / size.height;

    if (isRightImage) {
      dx -= 0.5;
    }

    print('Tapped at: (${localPosition.dx};${localPosition.dy})');
    print('Tapped at: ($dx;$dy)');

    if (differenceArea.contains(Offset(dx, dy))) {
      setState(() {
        highlightRect = Rect.fromPoints(
          Offset(localPosition.dx - 20, localPosition.dy - 20),
          Offset(localPosition.dx + 20, localPosition.dy + 20),
        );
      });
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
          onTapUp: (details) => onTap(details, context, isRightImage),
          child: Stack(
            children: [
              Image.asset(imageName),
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
        ),
      ),
    );
  }
}
