import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/highlighted_rect.dart';
import 'package:flutter_application_1/models/hole_painter.dart';
import 'package:flutter_application_1/models/image_pair.dart';

class DifferencesScreen extends StatefulWidget {
  final ImagePair imagePair;

  const DifferencesScreen({
    Key? key,
    required this.imagePair,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _DifferencesScreenState createState() => _DifferencesScreenState();
}

class _DifferencesScreenState extends State<DifferencesScreen> {
  List<Rect> highlightedRects = [];

  final GlobalKey leftImageKey = GlobalKey();
  final GlobalKey rightImageKey = GlobalKey();

  List<Rect> differenceAreas = [];

  late int remainingDifferences;

  int lives = 3;

  bool showHole = true; // change later

  @override
  void initState() {
    super.initState();
    differenceAreas =
        widget.imagePair.differenceAreas; // Initialize from widget
    remainingDifferences = differenceAreas.length;
  }

  void onTap(TapUpDetails details, BuildContext context, GlobalKey key) {
    // This RenderBox is for the widget to which the GlobalKey is attached.
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;

    // Gets the position of the RenderBox within the coordinate system of the screen.
    final Offset positionRelativeToScreen =
        renderBox.localToGlobal(Offset.zero);

    // Calculate the local position by subtracting the position relative to the screen.
    final Offset localPosition =
        details.globalPosition - positionRelativeToScreen;

    // ignore: avoid_print
    print(localPosition);

    // Now you have the local position of the tap within the widget itself.
    final size = renderBox.size;

    var dx = localPosition.dx / size.width;
    var dy = localPosition.dy / size.height;

    var x = localPosition.dx;
    var y = localPosition.dy;

    var isDifferenceSpotted = false;
    Rect? spottedArea;

    for (Rect area in differenceAreas) {
      if (area.contains(Offset(dx, dy))) {
        isDifferenceSpotted = true;
        spottedArea = area;
        break;
      }
    }

    if (isDifferenceSpotted) {
      setState(() {
        differenceAreas.remove(spottedArea);
        remainingDifferences--;

        highlightedRects.add(
          Rect.fromPoints(
            Offset(x - 50, y - 50),
            Offset(x + 50, y + 50),
          ),
        );

        if (remainingDifferences == 0) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => DifferencesScreen(
                imagePair: ImagePair(
                  topImage: 'assets/vintage_car_in_woods_2.png',
                  bottomImage: 'assets/vintage_car_in_woods_1.png',
                  differenceAreas: [
                    Rect.fromPoints(
                        const Offset(0.2, 0.2), const Offset(0.39, 0.39)),
                    Rect.fromPoints(
                        const Offset(0.5, 0.5), const Offset(0.69, 0.69)),
                  ],
                ),
              ),
            ));
          });
        }
      });
    } else {
      // ignore: avoid_print
      print('Not contained in any difference areas');
      // ignore: avoid_print
      print('${Offset(dx, dy)}');

      setState(() {
        if (lives > 0) {
          lives--; // Decrease the number of lives by 1
        }
        if (lives <= 0) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => DifferencesScreen(
                imagePair: ImagePair(
                  topImage: 'assets/vintage_car_in_woods_2.png',
                  bottomImage: 'assets/vintage_car_in_woods_1.png',
                  differenceAreas: [
                    Rect.fromPoints(
                        const Offset(0.2, 0.2), const Offset(0.39, 0.39)),
                    Rect.fromPoints(
                        const Offset(0.5, 0.5), const Offset(0.69, 0.69)),
                  ],
                ),
              ),
            ));
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top image
              Padding(
                padding: const EdgeInsets.all(1.0) +
                    const EdgeInsets.only(top: 20.0),
                child: buildImage(
                    context, widget.imagePair.topImage, leftImageKey),
              ),
              // Question mark differences counter
              if (remainingDifferences != 0 && lives > 0)
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: buildQuestionMarks(differenceAreas.length),
                  ),
                ]),
              if (remainingDifferences == 0 && lives > 0)
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "You found all the differences",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              if (lives <= 0)
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    "You lost!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),

              //Bottom image
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: buildImage(
                    context, widget.imagePair.bottomImage, rightImageKey),
              ),
              // Lightbulb button
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.yellow,
                  child: const Icon(Icons.lightbulb_outline),
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            child: buildHearts(),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: SizedBox(
              height: 30.0,
              width: 30.0,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    showHole = !showHole;
                  });
                },
                backgroundColor: Colors.white,
                child: const Icon(Icons.settings),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context, String imageName, GlobalKey key) {
    return GestureDetector(
      onTapUp: (details) => onTap(details, context, key),
      child: Container(
        key: key,
        child: Stack(
          children: [
            Image.asset(
              imageName,
              fit: BoxFit.cover,
            ),
            if (showHole) // Make sure you have a variable called showHole to control visibility
              Positioned.fill(
                child: CustomPaint(
                  painter: HolePainter(
                    Rect.fromPoints(
                      const Offset(0.1, 0.1), // Start point of the hole
                      const Offset(0.2, 0.2), // End point of the hole
                    ),
                  ),
                ),
              ),
            ...highlightedRects.map((rect) {
              return HighlightedRect(rect: rect);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget buildHearts() {
    return Row(
      children: List.generate(
        3, // Assuming a total of 3 lives
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

  Widget buildQuestionMarks(int count) {
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
