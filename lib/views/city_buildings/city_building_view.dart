import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_buildings/city_building_meta.dart';
import 'package:sloboda/views/components/soft_container.dart';

class CityBuildingImageView extends StatelessWidget {
  final CityBuilding building;

  CityBuildingImageView({this.building});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SoftContainer(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              CityBuildingDetailsScreen.routeName,
              arguments: CityBuildingDetailsScreenArguments(
                building: building,
              ),
            );
          },
          child: Image.asset(
            building.toIconPath(),
            height: 64,
          ),
        ),
      ),
    );
  }
}

class CityBuildingDetailsScreen extends StatelessWidget {
  static final String routeName = '/city_building/city_building_details';
  final CityBuilding building;

  CityBuildingDetailsScreen({this.building});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleText(
          SlobodaLocalizations.getForKey(building.localizedKey),
        ),
      ),
      body: SingleChildScrollView(
        child: CityBuildingMetaView(
          building: building,
          selected: true,
        ),
      ),
    );
  }
}

class CityBuildingDetailsScreenArguments {
  final CityBuilding building;

  CityBuildingDetailsScreenArguments({this.building});
}

class ExtractCityBuildingDetailsScreenArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final CityBuildingDetailsScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return CityBuildingDetailsScreen(
      building: args.building,
    );
  }
}
