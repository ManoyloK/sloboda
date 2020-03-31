import 'package:flutter/material.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/CityBuilder.dart';
import 'package:sloboda/views/components/add_worker_view.dart';
import 'package:sloboda/views/components/built_building_listview.dart';
import 'package:sloboda/views/components/resource_building_input_view.dart';
import 'package:sloboda/views/components/resource_building_output_view.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/components/workers_assigned_view.dart';

class ResourceBuildingBuiltListItemView extends StatelessWidget {
  final ResourceBuilding building;
  final Sloboda city;

  ResourceBuildingBuiltListItemView(
      {@required this.building, @required this.city});

  @override
  Widget build(BuildContext context) {
    return BuiltBuildingListItem(
      title: building.toLocalizedString(),
      producesIconPath: building.produces.toIconPath(),
      amount: building.outputAmount,
      buildingIconPath: building.toIconPath(),
      onPress: () {
        Navigator.pushNamed(
          context,
          ResourceBuildingBuilt.routeName,
          arguments: ResourceBuildingBuiltArguments(
            city: city,
            building: building,
          ),
        );
      },
    );
  }
}

class ResourceBuildingBuilt extends StatefulWidget {
  final ResourceBuilding building;
  final Sloboda city;
  static final String routeName = '/city_building/resource_building';

  ResourceBuildingBuilt({this.building, this.city});

  @override
  _ResourceBuildingBuiltState createState() => _ResourceBuildingBuiltState();
}

class _ResourceBuildingBuiltState extends State<ResourceBuildingBuilt> {
  @override
  Widget build(BuildContext context) {
    var city = widget.city;
    var building = widget.building;
    return Scaffold(
      appBar: AppBar(
        title: TitleText(
          building.toLocalizedString(),
        ),
      ),
      body: CityBuilder(
        city: city,
        builder: (context) => SingleChildScrollView(
          child: SoftContainer(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SoftContainer(
                      child: Image.asset(
                        building.toImagePath(),
                        height: 320,
                      ),
                    ),
                  ),
                  VDivider(),
                  SoftContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: WorkersAssignedView(
                        building: building,
                      ),
                    ),
                  ),
                  VDivider(),
                  SoftContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        building.toLocalizedDescriptionString(),
                      ),
                    ),
                  ),
                  if (!building.isFull()) ...[
                    VDivider(),
                    SoftContainer(
                      child: AddWorker(
                        building: building,
                        city: city,
                      ),
                    ),
                    VDivider(),
                  ],
                  if (!building.isFull()) ...[
                    SoftContainer(
                      child: SlideableButton(
                        onPress: !building.isFull()
                            ? () {
                                var freeCitizens = city
                                    .getAllFreeCitizens()
                                    .take(
                                      building.maxWorkers -
                                          building.assignedHumans.length,
                                    )
                                    .toList();
                                building.addWorkers(freeCitizens);
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TitleText(
                              SlobodaLocalizations.addMaxWorkers,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  VDivider(),
                  if (building.assignedHumans.isNotEmpty) ...[
                    SoftContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Center(
                              child:
                                  Text(SlobodaLocalizations.assignedWorkers)),
                          ...building.assignedHumans.map(
                            (h) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      h.name,
                                    ),
                                    SoftContainer(
                                      child: IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: !building.isEmpty()
                                            ? () {
                                                building.removeWorker(h);
                                              }
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ]),
                      ),
                    ),
                    VDivider(),
                  ],
                  if (building.requires.isNotEmpty &&
                      building.hasWorkers()) ...[
                    SoftContainer(
                      child: ResourceBuildingInputView(
                        building: building,
                      ),
                    ),
                    VDivider(),
                  ],
                  if (building.assignedHumans.isNotEmpty) ...[
                    SoftContainer(
                      child: ResourceBuildingOutputView(
                        building: building,
                      ),
                    ),
                    VDivider(),
                  ],
                  SizedBox(
                    height: 64,
                    child: SoftContainer(
                      child: SlideableButton(
                        child: Center(
                            child: Text(
                          SlobodaLocalizations.destroyBuilding,
                        )),
                        onPress: () {
                          city.removeResourceBuilding(building);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResourceBuildingBuiltArguments {
  final Sloboda city;
  final ResourceBuilding building;

  ResourceBuildingBuiltArguments({this.city, this.building});
}

class ExtractResourceBuildingBuiltArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final ResourceBuildingBuiltArguments args =
        ModalRoute.of(context).settings.arguments;

    return ResourceBuildingBuilt(
      city: args.city,
      building: args.building,
    );
  }
}
