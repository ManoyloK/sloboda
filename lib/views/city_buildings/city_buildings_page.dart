import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/animations/ink_well_overlay.dart';
import 'package:sloboda/views/animations/open_container_wrapper.dart';
import 'package:sloboda/views/city_buildings/city_building_built.dart';
import 'package:sloboda/views/city_buildings/city_building_meta.dart';
import 'package:sloboda/views/components/built_building_listview.dart';
import 'package:sloboda/views/components/soft_container.dart';

class CityBuildingsPage extends StatefulWidget {
  @override
  _CityBuildingsPageState createState() => _CityBuildingsPageState();
}

class _CityBuildingsPageState extends State<CityBuildingsPage> {
  CITY_BUILDING_TYPES selected;

  @override
  Widget build(BuildContext context) {
    var city = InheritedCity.of(context).city;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...city.cityBuildings.map(
            (cb) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SoftContainer(
                  child: OpenContainerWrapper(
                    child: CityBuildingBuilt(
                      building: cb,
                      city: city,
                    ),
                    transitionType: ContainerTransitionType.fade,
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      return InkWellOverlay(
                        openContainer: openContainer,
                        child: BuiltBuildingListItem(
                          title:
                              SlobodaLocalizations.getForKey(cb.localizedKey),
                          buildingIconPath: cb.toIconPath(),
                          producesIconPath: cb.produces.toIconPath(),
                          amount: cb.produces.value,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ).toList(),
          ...CITY_BUILDING_TYPES.values.map(
            (v) {
              var building = CityBuilding.fromType(v);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SoftContainer(
                  child: OpenContainerWrapper(
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          SlobodaLocalizations.getForKey(building.localizedKey),
                        ),
                      ),
                      body: CityBuildingMetaView(
                          building: building,
                          selected: true,
                          onBuildPressed: () {
                            try {
                              city.buildBuilding(building);
                            } catch (e) {
                              final snackBar = SnackBar(
                                content: Text(
                                  'Cannot build. Missing: ${e.localizedKey()}',
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          }),
                    ),
                    transitionType: ContainerTransitionType.fade,
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      return InkWellOverlay(
                        openContainer: openContainer,
                        child: CityBuildingMetaView(
                            building: building,
                            selected: false,
                            onBuildPressed: () {
                              try {
                                city.buildBuilding(building);
                              } catch (e) {
                                final snackBar = SnackBar(
                                    content: Text(
                                        'Cannot build. Missing: ${e.localizedKey()}'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                            }),
                      );
                    },
                  ),
                ),
              );
            },
          ).toList(),
        ],
      ),
    );
  }
}
