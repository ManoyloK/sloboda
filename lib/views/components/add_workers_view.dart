import 'package:flutter/material.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';

class AddWorkersButton extends StatefulWidget {
  final Sloboda city;
  final Producible building;
  final bool addMax;

  AddWorkersButton(
      {@required this.city, @required this.building, this.addMax: false});

  @override
  _AddWorkersButtonState createState() => _AddWorkersButtonState();
}

class _AddWorkersButtonState extends State<AddWorkersButton> {
  @override
  Widget build(BuildContext context) {
    var bCanAdd = !widget.building.isFull() && widget.city.hasFreeCitizens();
    var building = widget.building;
    return PressedInContainer(
      onPress: bCanAdd
          ? () {
              if (bCanAdd && widget.addMax) {
                var freeCitizens = widget.city
                    .getAllFreeCitizens()
                    .take(
                      building.maxWorkers - building.assignedHumans.length,
                    )
                    .toList();
                building.addWorkers(freeCitizens);
              }

              if (bCanAdd && !widget.addMax) {
                building.addWorker(widget.city.getFirstFreeCitizen());
              }
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: TitleText(
            _getTitleText(widget.city.hasFreeCitizens(), widget.addMax,
                widget.building.isFull()),
          ),
        ),
      ),
    );
  }

  String _getTitleText(bool hasFreeCitizens, bool addMax, bool isFull) {
    if (hasFreeCitizens) {
      if (isFull) {
        return SlobodaLocalizations.buildingIsFullOfWorkers;
      }
      if (addMax) {
        return SlobodaLocalizations.addMaxWorkers;
      } else {
        return SlobodaLocalizations.addWorker;
      }
    } else {
      return SlobodaLocalizations.noFreeWorkers;
    }
  }
}
