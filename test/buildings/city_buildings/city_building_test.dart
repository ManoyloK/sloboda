import 'package:sloboda/models/buildings/city_buildings/church.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/buildings/city_buildings/house.dart';
import 'package:sloboda/models/buildings/city_buildings/tower.dart';
import 'package:sloboda/models/buildings/city_buildings/wall.dart';
import 'package:sloboda/models/buildings/city_buildings/watch_tower.dart';
import 'package:test/test.dart';

void main() {
  group("Can (de)serialize City Buildings", () {
    test("Church", () {
      var building = Church();
      var map = building.toJson();
      var newBuilding = CityBuilding.fromJson(map);
      expect(newBuilding.type, equals(CITY_BUILDING_TYPES.CHURCH));
    });

    test("House", () {
      var building = House();
      var map = building.toJson();
      var newBuilding = CityBuilding.fromJson(map);
      expect(newBuilding.type, equals(CITY_BUILDING_TYPES.HOUSE));
    });

    test("Wall", () {
      var building = Wall();
      var map = building.toJson();
      var newBuilding = CityBuilding.fromJson(map);
      expect(newBuilding.type, equals(CITY_BUILDING_TYPES.WALL));
    });

    test("Watch Tower", () {
      var building = WatchTower();
      var map = building.toJson();
      var newBuilding = CityBuilding.fromJson(map);
      expect(newBuilding.type, equals(CITY_BUILDING_TYPES.WATCH_TOWER));
    });

    test("Tower", () {
      var building = Tower();
      var map = building.toJson();
      var newBuilding = CityBuilding.fromJson(map);
      expect(newBuilding.type, equals(CITY_BUILDING_TYPES.TOWER));
    });
  });
}
