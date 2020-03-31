import 'package:flutter/material.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/city_properties.dart';

class WorkersAssignedView extends StatelessWidget {
  final Producible building;

  WorkersAssignedView({this.building});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(CityCitizens().toIconPath(), width: 32),
        Text(
            '${this.building.assignedHumans.length}/${this.building.maxWorkers}'),
      ],
    );
  }
}
