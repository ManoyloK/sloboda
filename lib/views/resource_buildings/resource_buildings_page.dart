import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/animations/ink_well_overlay.dart';
import 'package:sloboda/views/animations/open_container_wrapper.dart';
import 'package:sloboda/views/components/built_building_listview.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/nature_resource_buildings.dart';
import 'package:sloboda/views/resource_buildings/resource_building_built.dart';
import 'package:sloboda/views/resource_buildings/resource_building_meta.dart';

class ResourceBuildingsPage extends StatefulWidget {
  @override
  _ResourceBuildingsPageState createState() => _ResourceBuildingsPageState();
}

class _ResourceBuildingsPageState extends State<ResourceBuildingsPage> {
  var selected;

  @override
  Widget build(BuildContext context) {
    var city = InheritedCity.of(context).city;
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...city.naturalResources.map<Widget>((el) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SoftContainer(
                  child: OpenContainerWrapper(
                    // what View to show after you click on element
                    child: NatureResourceBuildingScreen(
                      building: el,
                      city: city,
                    ),
                    transitionType: ContainerTransitionType.fade,
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      // what to show initially. Must be clickable
                      return InkWellOverlay(
                        openContainer: openContainer,
                        child: BuiltBuildingListItem(
                          title:
                              SlobodaLocalizations.getForKey(el.localizedKey),
                          buildingIconPath: el.iconPath,
                          producesIconPath: el.produces.toIconPath(),
                          amount: el.outputAmount,
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
            VDivider(),
            ...city.resourceBuildings
                .map<Widget>(
                  (building) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SoftContainer(
                      child: OpenContainerWrapper(
                        // what View to show after you click on element
                        child: ResourceBuildingBuilt(
                          building: building,
                          city: city,
                        ),
                        transitionType: ContainerTransitionType.fade,
                        closedBuilder:
                            (BuildContext _, VoidCallback openContainer) {
                          // what to show initially. Must be clickable
                          return InkWellOverlay(
                            openContainer: openContainer,
                            child: ResourceBuildingBuiltListItemView(
                              building: building,
                              city: city,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
                .toList(),
            // what can we build
            ...RESOURCE_BUILDING_TYPES.values.map((value) {
              var building = ResourceBuilding.fromType(value);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SoftContainer(
                  child: OpenContainerWrapper(
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          building.toLocalizedString(),
                        ),
                      ),
                      body: InheritedCity(
                        city: city,
                        child: ResourceBuildingMetaView(
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
                    ),
                    transitionType: ContainerTransitionType.fade,
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      return InkWellOverlay(
                        openContainer: openContainer,
                        child: InheritedCity(
                          city: city,
                          child: ResourceBuildingMetaView(
                              building: building,
                              selected: false,
                              onBuildPressed: () {
                                try {
                                  city.buildBuilding(building);
                                  Navigator.pop(context);
                                } catch (e) {
                                  final snackBar = SnackBar(
                                      content: Text(
                                          'Cannot build. Missing: ${e.localizedKey()}'));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                }
                              }),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ]),
    );
  }
}
