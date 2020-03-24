import 'package:flutter/material.dart';

class RotatableImage extends StatefulWidget {
  final String imagePath;
  final double width;

  RotatableImage({this.imagePath, this.width});
  @override
  _RotatableImageState createState() => _RotatableImageState();
}

class _RotatableImageState extends State<RotatableImage> {
  int position = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _rotate();
      },
      child: Image.asset(
        'images/city_buildings/sich_${position}.png',
        width: widget.width,
      ),
    );
  }

  _rotate() {
    position++;
    if (position >= 4) {
      position = 0;
    }

    setState(() {});
  }
}
