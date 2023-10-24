import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/highlighted_rect.dart';
import 'package:flutter_application_1/models/image_pair.dart';
import 'package:flutter_application_1/models/hearts_widget.dart';
import 'package:flutter_application_1/models/question_marks_widget.dart';

class DifferencesScreen extends StatefulWidget {
  final ImagePair imagePair;

  const DifferencesScreen({Key? key, required this.imagePair})
      : super(key: key);

  @override
  _DifferencesScreenState createState() => _DifferencesScreenState();
}

class _DifferencesScreenState extends State<DifferencesScreen> {
  List<Rect> highlightedRects = [];
  List<Rect> differenceAreas = [];
  int remainingDifferences = 0;
  int lives = 3;

  final GlobalKey leftImageKey = GlobalKey();
  final GlobalKey rightImageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initDifferenceAreas();
  }

  void initDifferenceAreas() {
    differenceAreas = widget.imagePair.differenceAreas;
    remainingDifferences = differenceAreas.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildMainContent(),
          buildOverlayWidgets(),
        ],
      ),
    );
  }

  Widget buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildImage(context, widget.imagePair.topImage, leftImageKey),
        buildQuestionMarkCounter(),
        buildGameStatusText(),
        buildImage(context, widget.imagePair.bottomImage, rightImageKey),
        buildHintButton(),
      ],
    );
  }

  Widget buildOverlayWidgets() {
    return Stack(
      children: [
        buildLivesIndicator(),
        buildSettingsButton(),
      ],
    );
  }

  Widget buildLivesIndicator() {
    return Positioned(
      top: 10,
      left: 10,
      child: HeartsWidget(
        startingLives: 3,
        lives: lives,
      ),
    );
  }

  Widget buildSettingsButton() {
    return Positioned(
      top: 10,
      right: 10,
      child: SizedBox(
        width: 30,
        height: 30,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.white,
          child: const Icon(Icons.settings),
        ),
      ),
    );
  }

  Widget buildQuestionMarkCounter() {
    return (remainingDifferences > 0 && lives > 0)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: QuestionMarksWidget(count: remainingDifferences),
              ),
            ],
          )
        : Container();
  }

  Widget buildGameStatusText() {
    if (remainingDifferences == 0 && lives > 0) {
      return buildStatusText("You found all the differences");
    }

    if (lives <= 0) {
      return buildStatusText("You lost!");
    }

    return Container();
  }

  Widget buildStatusText(String text) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget buildHintButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.lightbulb_outline),
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
            Image.asset(imageName, fit: BoxFit.cover),
            ...highlightedRects
                .map((rect) => HighlightedRect(rect: rect))
                .toList(),
          ],
        ),
      ),
    );
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
}
