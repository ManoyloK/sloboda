import 'dart:async';

import 'package:flutter/material.dart';

class RotatableImage extends StatefulWidget {
  final List<String> imagePaths;
  final double width;

  RotatableImage({this.imagePaths, this.width = 320.0});

  @override
  _RotatableImageState createState() => _RotatableImageState();
}

class _RotatableImageState extends State<RotatableImage> {
  int _position = 0;
  bool _visible = true;

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
          widget.imagePaths[_position],
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
    _position++;
    if (_position >= widget.imagePaths.length) {
      _position = 0;
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

List<String> generateRotatableImagesFromImage(String imagePath,
    [int amount = 4]) {
  var noExtension = imagePath.split(".png")[0];
  List<String> result = [];
  for (var i = 0; i < amount; i++) {
    result.add('${noExtension}_${i}.png');
  }
  return result;
}
