import 'package:sloboda/models/abstract/stock_item.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';

class Wall extends CityBuilding {
  CITY_BUILDING_TYPES type = CITY_BUILDING_TYPES.WALL;
  StockItem<CITY_PROPERTIES> produces = CityDefense(1);

  Map<RESOURCE_TYPES, int> requiredToBuild = {
    RESOURCE_TYPES.FOOD: 20,
    RESOURCE_TYPES.WOOD: 100,
  };

  String localizedKey = 'cityBuildings.wall';
  String localizedDescriptionKey = 'cityBuildings.wallDescription';

  String toIconPath() {
    return 'images/city_buildings/wall_64.png';
  }

  String toImagePath() {
    return 'images/city_buildings/wall.png';
  }

  Map<String, dynamic> toJson() {
    return {"type": "WALL"};
  }
}
