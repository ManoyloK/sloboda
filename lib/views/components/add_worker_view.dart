import 'package:flutter/material.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';

class AddWorker extends StatefulWidget {
  final Sloboda city;
  final Producible building;
  final VoidCallback onWorkerAdded;

  AddWorker({@required this.city, @required this.building, this.onWorkerAdded});

  @override
  _AddWorkerState createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
  @override
  Widget build(BuildContext context) {
    var bCanAdd = !widget.building.isFull() && widget.city.hasFreeCitizens();
    return SlideableButton(
      onPress: () {
        if (bCanAdd) {
          setState(() {
            widget.building.addWorker(widget.city.getFirstFreeCitizen());
            widget.onWorkerAdded();
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: TitleText(
            bCanAdd
                ? SlobodaLocalizations.addWorker
                : SlobodaLocalizations.noFreeWorkers,
          ),
        ),
      ),
    );
  }
}
