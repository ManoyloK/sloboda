import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';

class PressedInContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onPress;

  PressedInContainer({this.onPress, this.child});

  @override
  _PressedInContainerState createState() => _PressedInContainerState();
}

class _PressedInContainerState extends State<PressedInContainer>
    with SingleTickerProviderStateMixin {
  double firstDepth = -20;
  AnimationController _animationController;

  void initState() {
    _animationController = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 100),
    )
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed && widget.onPress != null) {
          widget.onPress();
          _animationController.reverse();
        }
      })
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double stagger(value, progress, delay) {
      progress = progress - (1 - delay);
      if (progress < 0) progress = 0;
      return value * (progress / delay);
    }

    double calculatedFirstDepth =
        stagger(firstDepth, _animationController.value, 1);

    return GestureDetector(
      onTap: () {
        if (widget.onPress != null) {
          _animationController.forward();
        }
      },
      child: ClayContainer(
        emboss: widget.onPress == null,
        color: Theme.of(context).backgroundColor,
        borderRadius: 15,
        depth: calculatedFirstDepth.toInt() == 0
            ? null
            : calculatedFirstDepth.toInt(),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
