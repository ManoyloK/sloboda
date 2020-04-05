import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/resources/resource.dart';

enum NATURAL_RESOURCES { RIVER, FOREST }

class NaturalResource with Producible {
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
}

class Forest extends NaturalResource {
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
