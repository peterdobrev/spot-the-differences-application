import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/image_pair.dart';
import 'package:flutter_application_1/screens/differences_screen.dart';

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
        home: DifferencesScreen(
          imagePair: ImagePair(
            leftImage: 'assets/vintage_car_in_woods_2.png',
            rightImage: 'assets/vintage_car_in_woods_1.png',
            differenceAreas: [
              Rect.fromPoints(const Offset(0.2, 0.2), const Offset(0.3, 0.3)),
              Rect.fromPoints(const Offset(0.5, 0.5), const Offset(0.6, 0.6)),
            ],
          ),
        ));
  }
}
