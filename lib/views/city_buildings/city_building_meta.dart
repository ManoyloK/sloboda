import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_buildings/city_building_output_view.dart';
import 'package:sloboda/views/components/buildable_requires_to_build.dart';
import 'package:sloboda/views/components/soft_container.dart';

class CityBuildingMetaView extends StatefulWidget {
  final CityBuilding building;
  final bool selected;
  final VoidCallback onBuildPressed;

  CityBuildingMetaView(
      {this.building, this.selected = false, this.onBuildPressed});

  @override
  _CityBuildingMetaViewState createState() => _CityBuildingMetaViewState();
}

class _CityBuildingMetaViewState extends State<CityBuildingMetaView> {
  @override
  Widget build(BuildContext context) {
    var building = widget.building;
    return SingleChildScrollView(
      child: SoftContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SoftContainer(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        SlobodaLocalizations.getForKey(building.localizedKey),
                        style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(fontSize: widget.selected ? 30 : 25)),
                      ),
                      VDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              building.toImagePath(),
                              height: widget.selected ? 256 : 128,
                            ),
                          ),
                          if (!widget.selected)
                            CityBuildingOutputView(
                              building: building,
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (widget.selected) ...[
                    SoftContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BuildableRequiredToBuildView(
                          building: building,
                        ),
                      ),
                    ),
                    VDivider(),
                    SoftContainer(
                      child: CityBuildingOutputView(
                        building: building,
                      ),
                    ),
                    VDivider(),
                  ],
                  if (widget.onBuildPressed != null)
                    PressedInContainer(
                      child: Container(
                          height: 64,
                          child: Center(
                            child: ButtonText(SlobodaLocalizations.build),
                          )),
                      onPress: widget.onBuildPressed,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
