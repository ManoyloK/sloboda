import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/abstract/stock_item.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/city_props_view.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

class ShootingRange implements Buildable<RESOURCE_TYPES> {
  String localizedKey = 'cityBuildings.shootingRange';
  StockItem<CITY_PROPERTIES> produces = CityCossacks();
  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 50,
    RESOURCE_TYPES.WOOD: 30,
  };

  Stock requiresForCossack = Stock(values: {
    RESOURCE_TYPES.FOOD: 10,
    RESOURCE_TYPES.FIREARM: 1,
    RESOURCE_TYPES.HORSE: 1,
  });

  bool canProduceCossack(
      CityProps cityProps, Stock stock, bool hasFreeCitizens) {
    return hasFreeCitizens &&
        requiresForCossack < stock &&
        cityProps.getByType(CITY_PROPERTIES.CITIZENS) >= 1;
  }

  Widget build(BuildContext context, Sloboda city) {
    var canProduce =
        canProduceCossack(city.props, city.stock, city.hasFreeCitizens());
    return SingleChildScrollView(
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
                    child: Hero(
                      tag: localizedKey,
                      child: Image.asset(
                        image,
                        height: 320,
                      ),
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
                              CITY_PROPERTIES.COSSACKS:
                                  city.props.getByType(CITY_PROPERTIES.COSSACKS)
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                VDivider(),
                PressedInContainer(
                  onPress: canProduce
                      ? () {
                          tryToCreateCossack(city);
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FullWidth(
                      child: Center(
                          child:
                              ButtonText(SlobodaLocalizations.trainCossacks)),
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
                      stock: requiresForCossack,
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
                          city.citizens
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
    );
  }

  void tryToCreateCossack(Sloboda city) {
    if (canProduceCossack(city.props, city.stock, city.hasFreeCitizens())) {
      city.stock - requiresForCossack;
      city.removeCitizens(amount: 1);
      city.addProps(
        CityProps(
          values: {
            CITY_PROPERTIES.COSSACKS: 1,
          },
        ),
      );
    }
  }

  get icon {
    return 'images/city_buildings/shooting_range_64.png';
  }

  get image {
    return 'images/city_buildings/shooting_range.png';
  }
}
