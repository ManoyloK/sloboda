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

  _getPrefix(String fullPath) {
    var noExtension = fullPath.split(".png");
    return noExtension[0];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _rotate();
      },
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: Duration(
          milliseconds: 50,
        ),
        child: Image.asset(
          _getPrefix(widget.imagePath) + '_${position}.png',
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
