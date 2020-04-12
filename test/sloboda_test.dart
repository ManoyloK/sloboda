import 'package:sloboda/models/buildings/city_buildings/church.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/buildings/city_buildings/house.dart';
import 'package:sloboda/models/buildings/city_buildings/tower.dart';
import 'package:sloboda/models/buildings/city_buildings/wall.dart';
import 'package:sloboda/models/buildings/city_buildings/watch_tower.dart';
import 'package:sloboda/models/buildings/resource_buildings/field.dart';
import 'package:sloboda/models/buildings/resource_buildings/mill.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/buildings/resource_buildings/smith.dart';
import 'package:sloboda/models/buildings/resource_buildings/stables.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/seasons.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/stock.dart';
import 'package:test/test.dart';

void main() {
  group("Can be initialized with default params", () {
    var city = Sloboda(name: 'Dmitrova', stock: Stock.defaultStock());
    test("Inits", () {
      expect(city, isNotNull);
      expect(city.name, equals('Dmitrova'));
    });

    test("Inits with default stock", () {
      expect(city.stock.getTypeKeys().length, equals(10));
      expect(city.stock.getByType(RESOURCE_TYPES.FOOD), equals(20));
    });

    test("Inits with 15 citizens", () {
      expect(city.props.getByType(CITY_PROPERTIES.CITIZENS), equals(15));
    });

    test("Inits with default buildings", () {
      expect(city.cityBuildings.length, equals(1));
      expect(city.cityBuildings[0] is House, isTrue);
    });
  });

  group("Can manage resource buildings", () {
    var city = Sloboda(name: 'Dimitrova');
    test("Can add resource building", () {
      var mill = Mill();
      mill.addWorker(city.getFirstFreeCitizen());
      city.resourceBuildings.add(mill);
      expect(city.getAllFreeCitizens().length, equals(14));
      expect(city.resourceBuildings.length, equals(1));
    });

    test("Can remove resource building", () {
      city.removeResourceBuilding(city.resourceBuildings[0]);
      expect(city.resourceBuildings.length, equals(0));
      expect(city.getAllFreeCitizens().length, equals(15));
    });
  });

  group("Stock management", () {
    var city = Sloboda(name: 'Dimitrova', disableRandomEvents: true);
    var field = Field();
    var smith = Smith();
    field.addWorker(city.getFirstFreeCitizen());
    smith.addWorker(city.getFirstFreeCitizen());
    city.resourceBuildings.add(field);
    city.resourceBuildings.add(smith);

    test("Checks that two citizens are occupied", () {
      expect(city.getAllFreeCitizens().length, 13);
    });

    test("makeTurn for city with Field, Smith with 1 worker", () {
      city.makeTurn();
      expect(city.stock.getByType(RESOURCE_TYPES.FOOD), equals(23));
      expect(city.stock.getByType(RESOURCE_TYPES.FIREARM), equals(2));
      expect(city.stock.getByType(RESOURCE_TYPES.POWDER), equals(4));
    });

    test("makeTurn for city with Field with 2 workers, Smith with 1 worker",
        () {
      field.addWorker(city.citizens[2]);
      city.makeTurn();
      expect(city.getAllFreeCitizens().length, 18);
      expect(city.stock.getByType(RESOURCE_TYPES.FOOD), equals(33));
    });
  });

  group(
    'City events management',
    () {
      var city = Sloboda(name: 'Dimitrova');
      var field = Field();
      city.buildBuilding(field);

      test('City inits without events', () {
        expect(city.events.isEmpty, true);
      });

      test(
        'Generates three events for no workers assigned to default Forest and River and new Field',
        () {
          city.makeTurn();
          expect(
            city.events.length,
            equals(3),
          );
        },
      );

      test(
        'Generates two more events for no workers assigned to default Forest and River',
        () {
          field.addWorker(Citizen());
          city.makeTurn();
          expect(
            city.events.length >= 5,
            true,
          );
        },
      );

      test(
        'Generates no additional events when Forest and River have workers',
        () {
          city.naturalResources[0].addWorker(city.getFirstFreeCitizen());
          city.naturalResources[1].addWorker(city.getFirstFreeCitizen());
          city.makeTurn();
          expect(city.events.length >= 5, true);
        },
      );

      test(
        'Generates one additional event when Smith has no IRON for input',
        () {
          var smith = Smith();
          city.buildBuilding(smith);
          smith.addWorker(city.getFirstFreeCitizen());
          // iron is 1 before this turn
          city.makeTurn();
          // iron is 0 after this turn
          city.makeTurn();
          expect(
            city.events.length >= 6,
            equals(true),
          );
        },
      );
    },
  );

  group("Can serialize and restore state", () {
    Sloboda city;
    setUp(() {
      city = Sloboda(name: 'Dimitrova', stock: Stock.bigStock());
      city.currentYear = 1555;
      city.foundedYear = 1551;
      city.currentSeason = SummerSeason();
      city.makeTurn();
    });

    test("Can (de)serialize name", () {
      var map = city.toJson();
      var newCity = Sloboda.fromJson(map);
      expect(newCity.name, equals(city.name));
    });

    test("Can (de)serialize currentYear", () {
      var map = city.toJson();
      var newCity = Sloboda.fromJson(map);
      expect(newCity.currentYear, equals(city.currentYear));
    });

    test("Can (de)serialize foundedYear", () {
      var map = city.toJson();
      var newCity = Sloboda.fromJson(map);
      expect(newCity.foundedYear, equals(city.foundedYear));
    });

    test("Can (de)serialize foundedYear", () {
      var map = city.toJson();
      var newCity = Sloboda.fromJson(map);
      expect(newCity.foundedYear, equals(city.foundedYear));
    });

    test("Can (de)serialize currentSeason", () {
      var map = city.toJson();
      var newCity = Sloboda.fromJson(map);
      expect(newCity.currentSeason.type, equals(CITY_SEASONS.AUTUMN));
    });

    test("Can (de)serialize city buildings", () {
      city.buildBuilding(House());
      city.buildBuilding(Church());
      city.buildBuilding(Tower());
      city.buildBuilding(WatchTower());
      city.buildBuilding(Wall());
      var map = city.toJson();
      var newCity = Sloboda.fromJson(map);
      expect(newCity.cityBuildings[1].type, equals(CITY_BUILDING_TYPES.HOUSE));
      expect(newCity.cityBuildings[2].type, equals(CITY_BUILDING_TYPES.CHURCH));
      expect(newCity.cityBuildings[3].type, equals(CITY_BUILDING_TYPES.TOWER));
      expect(newCity.cityBuildings[4].type,
          equals(CITY_BUILDING_TYPES.WATCH_TOWER));
      expect(newCity.cityBuildings[5].type, equals(CITY_BUILDING_TYPES.WALL));
    });

    test("Can (de)serialize list of citizens", () {
      city.addCitizens(amount: 5);
      var map = city.toJson();
      var newCity = Sloboda.fromJson(map);
      expect(newCity.citizens.length, equals(city.citizens.length));
    });

    test("Can (de)serialize list resource buildings", () {
      city.buildBuilding(Smith());
      city.buildBuilding(Stables());
      var map = city.toJson();
      var newCity = Sloboda.fromJson(map);
      expect(newCity.resourceBuildings.length,
          equals(city.resourceBuildings.length));
      expect(newCity.resourceBuildings[0].type,
          equals(RESOURCE_BUILDING_TYPES.SMITH));

      expect(newCity.resourceBuildings[1].type,
          equals(RESOURCE_BUILDING_TYPES.STABLES));
    });

    test("Can (de)serialize CityProps", () {
      city.props.setType(CITY_PROPERTIES.COSSACKS, 100);
      city.props.setType(CITY_PROPERTIES.CITIZENS, 20);
      city.props.setType(CITY_PROPERTIES.FAITH, 25);
      city.props.setType(CITY_PROPERTIES.GLORY, 13);
      city.props.setType(CITY_PROPERTIES.DEFENSE, 130);
      var map = city.toJson();
      var newCity = Sloboda.fromJson(map);

      expect(newCity.props.getByType(CITY_PROPERTIES.COSSACKS),
          equals(city.props.getByType(CITY_PROPERTIES.COSSACKS)));

      expect(newCity.props.getByType(CITY_PROPERTIES.CITIZENS),
          equals(city.props.getByType(CITY_PROPERTIES.CITIZENS)));

      expect(newCity.props.getByType(CITY_PROPERTIES.FAITH),
          equals(city.props.getByType(CITY_PROPERTIES.FAITH)));

      expect(newCity.props.getByType(CITY_PROPERTIES.GLORY),
          equals(city.props.getByType(CITY_PROPERTIES.GLORY)));

      expect(newCity.props.getByType(CITY_PROPERTIES.DEFENSE),
          equals(newCity.props.getByType(CITY_PROPERTIES.DEFENSE)));
    });
  });
}
