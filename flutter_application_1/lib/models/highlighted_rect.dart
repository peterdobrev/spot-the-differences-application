import 'package:flutter/material.dart';

class HighlightedRect extends StatefulWidget {
  final Rect rect;

  const HighlightedRect({super.key, required this.rect});

  @override
  // ignore: library_private_types_in_public_api
  _HighlightedRectState createState() => _HighlightedRectState();
}

class _HighlightedRectState extends State<HighlightedRect> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.rect.left,
      top: widget.rect.top,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: widget.rect.width,
          height: widget.rect.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
