import 'package:sloboda/models/abstract/stock_item.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';

class Tower extends CityBuilding {
  CITY_BUILDING_TYPES type = CITY_BUILDING_TYPES.TOWER;
  StockItem<CITY_PROPERTIES> produces = CityDefense(1);

  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 100,
    RESOURCE_TYPES.STONE: 20,
    RESOURCE_TYPES.WOOD: 50,
    RESOURCE_TYPES.MONEY: 20
  };

  String localizedKey = 'cityBuildings.tower';
  String localizedDescriptionKey = 'cityBuildings.towerDescription';

  String toIconPath() {
    return 'images/city_buildings/tower_64.png';
  }

  String toImagePath() {
    return 'images/city_buildings/tower.png';
  }

  Map<String, dynamic> toJson() {
    return {"type": "TOWER"};
  }
}
