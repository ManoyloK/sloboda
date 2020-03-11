import 'package:flutter/material.dart';

const DIVIDER_VALUE = 35.0;

class VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DIVIDER_VALUE,
    );
  }
}

class HDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DIVIDER_VALUE,
    );
  }
}

class AllDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DIVIDER_VALUE,
    );
  }
}
