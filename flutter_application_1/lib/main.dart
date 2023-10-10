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

  final GlobalKey leftImageKey = GlobalKey();
  final GlobalKey rightImageKey = GlobalKey();

  final Rect differenceArea = Rect.fromPoints(
    const Offset(0.0, 0.0),
    const Offset(1.0, 1.0),
  );

  void onTap(TapUpDetails details, BuildContext context, bool isBottomImage,
      GlobalKey key) {
    // This RenderBox is for the widget to which the GlobalKey is attached.
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;

    // Gets the position of the RenderBox within the coordinate system of the screen.
    final Offset positionRelativeToScreen =
        renderBox.localToGlobal(Offset.zero);

    // Calculate the local position by subtracting the position relative to the screen.
    final Offset localPosition =
        details.globalPosition - positionRelativeToScreen;

    print(localPosition);

    // Now you have the local position of the tap within the widget itself.
    final size = renderBox.size;

    var dx = localPosition.dx / size.width;
    var dy = localPosition.dy / size.height;

    var x = localPosition.dx;
    var y = localPosition.dy;

    if (isBottomImage) {
      //dy -= 0.5; // Offset if it is the bottom image
    }

    if (differenceArea.contains(Offset(dx, dy))) {
      setState(() {
        highlightRect = Rect.fromPoints(
          Offset(x - 50, y - 50),
          Offset(x + 50, y + 50),
        );
      });
    } else {
      print('Not contained in $differenceArea ');
      print('${Offset(dx, dy)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // This is your AppBar
        title: const Text("Spot the Differences"),
      ),
      body: Column(
        // Changed from Row to Column
        children: [
          buildImage(context, 'assets/vintage_car_in_woods_1.png', false,
              leftImageKey),
          buildImage(context, 'assets/vintage_car_in_woods_2.png', true,
              rightImageKey),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context, String imageName, bool isBottomImage,
      GlobalKey key) {
    return Expanded(
      child: GestureDetector(
        key: key,
        onTapUp: (details) => onTap(details, context, isBottomImage, key),
        child: Stack(
          children: [
            Image.asset(
              imageName,
              fit: BoxFit.cover,
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
      ),
    );
  }
}
