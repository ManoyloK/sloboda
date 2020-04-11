import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/resources/resource.dart';

enum NATURAL_RESOURCES { RIVER, FOREST }

class NaturalResource with Producible {
  NaturalResource();
  NATURAL_RESOURCES type;
  ResourceType produces;

  String get iconPath {
    return 'images/resource_buildings/mill.png';
  }

  String get localizedKey {
    throw UnimplementedError();
  }

  String get localizedDescriptionKey {
    throw UnimplementedError();
  }

  factory NaturalResource.fromJson(Map<String, dynamic> json) {
    var type = json["type"];
    NaturalResource resource;
    switch (type) {
      case "FOREST":
        resource = Forest();
        break;
      case "RIVER":
        resource = River();
        break;
      default:
        throw 'Natural Resource $type is not recognized';
    }

    resource.assignedHumans = (json["assignedHumars"] as List)
        .map((json) => Citizen.fromJson(json))
        .toList();
    return resource;
  }

  Map<String, dynamic> toJson() {
    return {
      "type": naturalResourceTypeToString(type),
      "assignedHumars": assignedHumans.map((h) => h.toJson()).toList()
    };
  }
}

String naturalResourceTypeToString(NATURAL_RESOURCES res) {
  switch (res) {
    case NATURAL_RESOURCES.FOREST:
      return "FOREST";
    case NATURAL_RESOURCES.RIVER:
      return "RIVER";
  }
}

class Forest extends NaturalResource {
  Forest();
  NATURAL_RESOURCES type = NATURAL_RESOURCES.FOREST;
  int maxWorkers = 300;
  int workMultiplier = 2;
  ResourceType produces = Wood();
  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 1,
  };

  String get iconPath {
    return 'images/resource_buildings/forest.png';
  }

  String get localizedKey {
    return 'natureResources.forest';
  }

  String get localizedDescriptionKey {
    return 'natureResources.forestDescription';
  }
}

class River extends NaturalResource {
  River();
  NATURAL_RESOURCES type = NATURAL_RESOURCES.RIVER;
  int maxWorkers = 50;
  int workMultiplier = 2;
  ResourceType produces = Fish();
  Map<RESOURCE_TYPES, int> requires = {
    RESOURCE_TYPES.FOOD: 1,
  };

  String get iconPath {
    return 'images/resource_buildings/river.png';
  }

  String get localizedKey {
    return 'natureResources.river';
  }

  String get localizedDescriptionKey {
    return 'natureResources.riverDescription';
  }
}
