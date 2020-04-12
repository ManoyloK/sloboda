import 'package:sloboda/extensions/int.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/buildings/resource_buildings/field.dart';
import 'package:sloboda/models/buildings/resource_buildings/hunting_house.dart';
import 'package:sloboda/models/buildings/resource_buildings/iron_mine.dart';
import 'package:sloboda/models/buildings/resource_buildings/mill.dart';
import 'package:sloboda/models/buildings/resource_buildings/powder_cellar.dart';
import 'package:sloboda/models/buildings/resource_buildings/quarry.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/buildings/resource_buildings/smith.dart';
import 'package:sloboda/models/buildings/resource_buildings/stables.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/stock.dart';
import 'package:test/test.dart';

void main() {
  group("Smith Main Tests", () {
    var smith = Smith();
    Stock stock = Stock(values: {
      RESOURCE_TYPES.FOOD: 5,
      RESOURCE_TYPES.FIREARM: 0,
      RESOURCE_TYPES.POWDER: 1,
      RESOURCE_TYPES.IRON_ORE: 1,
    });

    test("Does not require other resources", () {
      expect(smith.requires, isNotEmpty);
    });

    test("Can add worker", () {
      smith.addWorker(Citizen());
      expect(smith.hasWorkers(), isTrue);
    });

    test("Can tell if workers are assigned", () {
      expect(smith.hasWorkers(), isTrue);
    });

    test("Can generate firearm with 1 worker", () {
      smith.generate(stock);
      expect(stock.getByType(RESOURCE_TYPES.FIREARM), equals(1));
      expect(stock.getByType(RESOURCE_TYPES.FOOD), equals(3));
    });

    test("Can remove workers", () {
      var removedWorker = smith.assignedHumans[0];
      smith.removeWorker(removedWorker);
      expect(smith.assignedHumans.indexOf(removedWorker) < 0, true);
      expect(smith.hasWorkers(), isFalse);
    });

    test("Cannot generate resource when no workers assigned", () {
      expect(() => smith.generate(stock),
          throwsA(TypeMatcher<NotEnoughWorkers>()));
    });

    test("Cannot add more workers than allowed", () {
      30.timesRepeat(() => smith.addWorker(Citizen()));

      expect(() => smith.addWorker(Citizen()),
          throwsA(TypeMatcher<BuildingFull>()));
    });
  });

  group("Can (de)serialize from json", () {
    test("Smith", () {
      var building = Smith();
      building.addWorkers([Citizen(), Citizen()]);
      var json = building.toJson();
      var newBuilding = ResourceBuilding.fromJson(json);
      expect(newBuilding.type, equals(building.type));
      expect(newBuilding.assignedHumans[0].name,
          equals(building.assignedHumans[0].name));
      expect(newBuilding.assignedHumans.length,
          equals(building.assignedHumans.length));
    });

    test("Field", () {
      var building = Field();
      building.addWorkers([Citizen(), Citizen()]);
      var json = building.toJson();
      var newBuilding = ResourceBuilding.fromJson(json);
      expect(newBuilding.type, equals(building.type));
      expect(newBuilding.assignedHumans[0].name,
          equals(building.assignedHumans[0].name));
      expect(newBuilding.assignedHumans.length,
          equals(building.assignedHumans.length));
    });

    test("Mill", () {
      var building = Mill();
      building.addWorkers([Citizen(), Citizen()]);
      var json = building.toJson();
      var newBuilding = ResourceBuilding.fromJson(json);
      expect(newBuilding.type, equals(building.type));
      expect(newBuilding.assignedHumans[0].name,
          equals(building.assignedHumans[0].name));
      expect(newBuilding.assignedHumans.length,
          equals(building.assignedHumans.length));
    });

    test("Quarry", () {
      var building = Quarry();
      building.addWorkers([Citizen(), Citizen()]);
      var json = building.toJson();
      var newBuilding = ResourceBuilding.fromJson(json);
      expect(newBuilding.type, equals(building.type));
      expect(newBuilding.assignedHumans[0].name,
          equals(building.assignedHumans[0].name));
      expect(newBuilding.assignedHumans.length,
          equals(building.assignedHumans.length));
    });

    test("Stables", () {
      var building = Stables();
      building.addWorkers([Citizen(), Citizen()]);
      var json = building.toJson();
      var newBuilding = ResourceBuilding.fromJson(json);
      expect(newBuilding.type, equals(building.type));
      expect(newBuilding.assignedHumans[0].name,
          equals(building.assignedHumans[0].name));
      expect(newBuilding.assignedHumans.length,
          equals(building.assignedHumans.length));
    });

    test("Iron Mine", () {
      var building = IronMine();
      building.addWorkers([Citizen(), Citizen()]);
      var json = building.toJson();
      var newBuilding = ResourceBuilding.fromJson(json);
      expect(newBuilding.type, equals(building.type));
      expect(newBuilding.assignedHumans[0].name,
          equals(building.assignedHumans[0].name));
      expect(newBuilding.assignedHumans.length,
          equals(building.assignedHumans.length));
    });

    test("Trapper House", () {
      var building = TrapperHouse();
      building.addWorkers([Citizen(), Citizen()]);
      var json = building.toJson();
      var newBuilding = ResourceBuilding.fromJson(json);
      expect(newBuilding.type, equals(building.type));
      expect(newBuilding.assignedHumans[0].name,
          equals(building.assignedHumans[0].name));
      expect(newBuilding.assignedHumans.length,
          equals(building.assignedHumans.length));
    });

    test("Powder Cellar", () {
      var building = PowderCellar();
      building.addWorkers([Citizen(), Citizen()]);
      var json = building.toJson();
      var newBuilding = ResourceBuilding.fromJson(json);
      expect(newBuilding.type, equals(building.type));
      expect(newBuilding.assignedHumans[0].name,
          equals(building.assignedHumans[0].name));
      expect(newBuilding.assignedHumans.length,
          equals(building.assignedHumans.length));
    });
  });
}
