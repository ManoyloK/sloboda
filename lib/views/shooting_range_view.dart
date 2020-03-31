import 'package:flutter/material.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/buildings/shooting_range.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_props_view.dart';
import 'package:sloboda/views/components/CityBuilder.dart';
import 'package:sloboda/views/components/built_building_listview.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

class ShootingRangeView extends StatelessWidget {
  final ShootingRange building;

  ShootingRangeView({this.building});

  @override
  Widget build(BuildContext context) {
    return BuiltBuildingListItem(
      title: SlobodaLocalizations.getForKey(building.localizedKey),
      buildingIconPath: building.icon,
      producesIconPath: building.produces.toIconPath(),
      amount: 1,
    );
  }
}

class ShootingRangeBuilt extends StatefulWidget {
  final ShootingRange building;
  final Sloboda city;
  static final String routeName = '/city_building/shooting_range';

  ShootingRangeBuilt({this.building, this.city});

  @override
  _ShootingRangeBuiltState createState() => _ShootingRangeBuiltState();
}

class _ShootingRangeBuiltState extends State<ShootingRangeBuilt> {
  @override
  Widget build(BuildContext context) {
    var building = widget.building;
    var city = widget.city;
    return Scaffold(
      appBar: AppBar(
        title: TitleText(
          SlobodaLocalizations.getForKey(building.localizedKey),
        ),
      ),
      body: CityBuilder(
        city: widget.city,
        builder: (context) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SoftContainer(
                        child: Image.asset(
                          building.image,
                          height: 320,
                        ),
                      ),
                    ),
                    VDivider(),
                    FullWidth(
                      child: SoftContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CityPropsMiniView(
                              props: CityProps(
                                values: {
                                  CITY_PROPERTIES.COSSACKS: city.props
                                      .getByType(CITY_PROPERTIES.COSSACKS)
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    VDivider(),
                    SoftContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FullWidth(
                          child: SlideableButton(
                            child: Center(
                                child: ButtonText(
                                    SlobodaLocalizations.trainCossacks)),
                            onPress: building.canProduceCossack(
                                    city.props, city.stock)
                                ? () {
                                    building.tryToCreateCossack(city, () {});
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ),
                    VDivider(),
                    TitleText(SlobodaLocalizations.requiredForProductionBy),
                    VDivider(),
                    SoftContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StockFullView(
                          stock: building.requiresForCossack,
                          stockSimulation: null,
                        ),
                      ),
                    ),
                    VDivider(),
                    SoftContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleText(SlobodaLocalizations.notOccupiedCitizens),
                            Text(
                              widget.city.citizens
                                  .where((citizen) => !citizen.occupied)
                                  .toList()
                                  .length
                                  .toString(),
                            )
                          ],
                        ),
                      ),
                    ),
                    VDivider(),
                    SoftContainer(
                      child: StockFullView(
                        stock: city.stock,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShootingRangeViewArguments {
  final Sloboda city;
  final ShootingRange building;

  ShootingRangeViewArguments({this.city, this.building});
}

class ExtractShootingRangeBuiltArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final ShootingRangeViewArguments args =
        ModalRoute.of(context).settings.arguments;

    return ShootingRangeBuilt(
      city: args.city,
      building: args.building,
    );
  }
}
