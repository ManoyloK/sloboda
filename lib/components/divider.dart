import 'package:flutter/material.dart';

const DIVIDER_VALUE = 35.0;
const SMALL_DIVIDER_VALUE = 12.0;

class VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: DIVIDER_VALUE,
    );
  }
}

class SVDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SMALL_DIVIDER_VALUE,
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
