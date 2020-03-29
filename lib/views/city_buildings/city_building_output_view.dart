import 'package:flutter/material.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_buildings/city_property_image_view.dart';

class CityBuildingOutputView extends StatelessWidget {
  final CityBuilding building;

  CityBuildingOutputView({this.building});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(SlobodaLocalizations.output),
        CityPropertyImageView(
          prop: building.produces,
          amount: building.produces.value,
        )
      ],
    );
  }
}
