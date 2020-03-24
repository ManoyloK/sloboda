import 'dart:async';

import 'package:flutter/material.dart';

class RotatableImage extends StatefulWidget {
  final String imagePath;
  final double width;

  RotatableImage({this.imagePath, this.width = 320.0});

  @override
  _RotatableImageState createState() => _RotatableImageState();
}

class _RotatableImageState extends State<RotatableImage> {
  int position = 0;
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _rotate();
      },
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: Duration(
          milliseconds: 50,
        ),
        child: Image.asset(
          'images/city_buildings/sich_${position}.png',
          width: widget.width,
        ),
      ),
    );
  }

  _toggleOpacity() {
    setState(() {
      _visible = true;
    });
  }

  _rotate() {
    position++;
    if (position >= 4) {
      position = 0;
    }
    setState(() {
      _visible = false;
    });
    Timer(
        Duration(
          milliseconds: 50,
        ),
        _toggleOpacity);
  }
}
