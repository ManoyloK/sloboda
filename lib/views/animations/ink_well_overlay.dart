import 'package:flutter/material.dart';

class InkWellOverlay extends StatelessWidget {
  const InkWellOverlay({
    this.openContainer,
    this.child,
  });

  final VoidCallback openContainer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openContainer,
      child: child,
    );
  }
}
