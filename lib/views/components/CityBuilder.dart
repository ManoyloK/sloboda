import 'package:flutter/material.dart';
import 'package:sloboda/models/sloboda.dart';

class CityBuilder extends StatefulWidget {
  final Sloboda city;

  final Function(BuildContext context) builder;

  CityBuilder({this.city, this.builder});

  @override
  _CityBuilderState createState() => _CityBuilderState();
}

class _CityBuilderState extends State<CityBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.city.changes,
      builder: (context, snapshot) {
        return widget.builder(context);
      },
    );
  }
}
