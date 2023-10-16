import 'package:flutter/material.dart';
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DifferencesScreen(
              imagePair: ImagePair(
                leftImage: 'assets/vintage_car_in_woods_2.png',
                rightImage: 'assets/vintage_car_in_woods_1.png',
                differenceAreas: [
                  Rect.fromPoints(
                      const Offset(0.2, 0.2), const Offset(0.3, 0.3)),
                  Rect.fromPoints(
                      const Offset(0.5, 0.5), const Offset(0.6, 0.6)),
                ],
              ),
            ),
          ));
        }
      });
    } else {
      // ignore: avoid_print
      print('Not contained in any difference areas');
      // ignore: avoid_print
      print('${Offset(dx, dy)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spot the Differences"),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child:
                buildImage(context, widget.imagePair.leftImage, leftImageKey),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Differences remaining - $remainingDifferences",
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child:
                buildImage(context, widget.imagePair.rightImage, rightImageKey),
          ),
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
            ...highlightedRects
                .map((rect) => Positioned(
                      left: rect.left,
                      top: rect.top,
                      child: Container(
                        width: rect.width,
                        height: rect.height,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
