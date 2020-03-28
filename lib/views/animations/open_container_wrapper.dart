import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper(
      {this.closedBuilder, this.transitionType, this.child});

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return child;
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
