import 'package:sloboda/models/abstract/stock_item.dart';

enum RESOURCE_TYPES {
  MONEY,
  WOOD,
  FOOD,
  STONE,
  POWDER,
  FUR,
  FISH,
  FIREARM,
  HORSE,
  IRON_ORE,
}

String resourceTypesToString(RESOURCE_TYPES type) {
  switch (type) {
    case RESOURCE_TYPES.MONEY:
      return "MONEY";
    case RESOURCE_TYPES.WOOD:
      return "WOOD";
    case RESOURCE_TYPES.FOOD:
      return "FOOD";
    case RESOURCE_TYPES.STONE:
      return "STONE";
    case RESOURCE_TYPES.POWDER:
      return "POWDER";
    case RESOURCE_TYPES.FUR:
      return "FUR";
    case RESOURCE_TYPES.FISH:
      return "FISH";
    case RESOURCE_TYPES.FIREARM:
      return "FIREARM";
    case RESOURCE_TYPES.HORSE:
      return "HORSE";
    case RESOURCE_TYPES.IRON_ORE:
      return "IRON_ORE";
    default:
      throw 'Resource type $type is not recognized';
  }
}

RESOURCE_TYPES stringToResourceType(String type) {
  switch (type) {
    case "MONEY":
      return RESOURCE_TYPES.MONEY;
    case "WOOD":
      return RESOURCE_TYPES.WOOD;
    case "FOOD":
      return RESOURCE_TYPES.FOOD;
    case "STONE":
      return RESOURCE_TYPES.STONE;
    case "POWDER":
      return RESOURCE_TYPES.POWDER;
    case "FUR":
      return RESOURCE_TYPES.FUR;
    case "FISH":
      return RESOURCE_TYPES.FISH;
    case "FIREARM":
      return RESOURCE_TYPES.FIREARM;
    case "HORSE":
      return RESOURCE_TYPES.HORSE;
    case "IRON_ORE":
      return RESOURCE_TYPES.IRON_ORE;
    default:
      throw 'Resource type $type is not recognized';
  }
}

abstract class ResourceType extends StockItem<RESOURCE_TYPES> {
  static StockItem<RESOURCE_TYPES> fromType(RESOURCE_TYPES type, [int value]) {
    switch (type) {
      case RESOURCE_TYPES.FIREARM:
        return FireArm(value);
      case RESOURCE_TYPES.FISH:
        return Fish(value);
      case RESOURCE_TYPES.FOOD:
        return Food(value);
      case RESOURCE_TYPES.FUR:
        return Fur(value);
      case RESOURCE_TYPES.IRON_ORE:
        return IronOre(value);
      case RESOURCE_TYPES.STONE:
        return Stone(value);
      case RESOURCE_TYPES.WOOD:
        return Wood(value);
      case RESOURCE_TYPES.MONEY:
        return Money(value);
      case RESOURCE_TYPES.HORSE:
        return Horse(value);
      case RESOURCE_TYPES.POWDER:
        return Powder(value);
    }
  }

  static StockItem<RESOURCE_TYPES> fromKey(String key, [int value]) {
    switch (key) {
      case 'resources.firearm':
        return FireArm(value);
      case 'resources.fish':
        return Fish(value);
      case 'resources.food':
        return Food(value);
      case 'resources.fur':
        return Fur(value);
      case 'resources.ore':
        return IronOre(value);
      case 'resources.stone':
        return Stone(value);
      case 'resources.wood':
        return Wood(value);
      case 'resources.money':
        return Money(value);
      case 'resources.horse':
        return Horse(value);
      case 'resources.powder':
        return Powder(value);
    }
  }

  ResourceType([value]) : super(value);
}

class Powder extends ResourceType {
  String localizedKey = 'resources.powder';
  String localizedDescriptionKey = 'resources.powderDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.POWDER;

  String toImagePath() {
    return 'images/resources/powder.png';
  }

  String toIconPath() {
    return 'images/resources/powder_64.png';
  }

  Powder([value]) : super(value);
}

class Horse extends ResourceType {
  String localizedKey = 'resources.horse';
  String localizedDescriptionKey = 'resources.horseDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.HORSE;

  String toImagePath() {
    return 'images/resources/horse.png';
  }

  String toIconPath() {
    return 'images/resources/horse_64.png';
  }

  Horse([value]) : super(value);
}

class Money extends ResourceType {
  String localizedKey = 'resources.money';
  String localizedDescriptionKey = 'resources.moneyDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.MONEY;

  String toImagePath() {
    return 'images/resources/money.png';
  }

  String toIconPath() {
    return 'images/resources/money_64.png';
  }

  Money([value]) : super(value);
}

class Wood extends ResourceType {
  String localizedKey = 'resources.wood';
  String localizedDescriptionKey = 'resources.woodDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.WOOD;

  String toImagePath() {
    return 'images/resources/wood.png';
  }

  String toIconPath() {
    return 'images/resources/wood_64.png';
  }

  Wood([value]) : super(value);
}

class Stone extends ResourceType {
  String localizedKey = 'resources.stone';
  String localizedDescriptionKey = 'resources.stoneDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.STONE;

  String toImagePath() {
    return 'images/resources/stone.png';
  }

  String toIconPath() {
    return 'images/resources/stone_64.png';
  }

  Stone([value]) : super(value);
}

class FireArm extends ResourceType {
  String localizedKey = 'resources.firearm';
  String localizedDescriptionKey = 'resources.firearmDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.FIREARM;

  String toImagePath() {
    return 'images/resources/firearm.png';
  }

  String toIconPath() {
    return 'images/resources/firearm_64.png';
  }

  FireArm([value]) : super(value);
}

class Fish extends ResourceType {
  String localizedKey = 'resources.fish';
  String localizedDescriptionKey = 'resources.fishDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.FISH;

  String toImagePath() {
    return 'images/resources/fish.png';
  }

  String toIconPath() {
    return 'images/resources/fish_64.png';
  }

  Fish([value]) : super(value);
}

class Food extends ResourceType {
  String localizedKey = 'resources.food';
  String localizedDescriptionKey = 'resources.foodDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.FOOD;

  String toImagePath() {
    return 'images/resources/food.png';
  }

  String toIconPath() {
    return 'images/resources/food_64.png';
  }

  Food([value]) : super(value);
}

class Fur extends ResourceType {
  String localizedKey = 'resources.fur';
  String localizedDescriptionKey = 'resources.furDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.FUR;

  String toImagePath() {
    return 'images/resources/fur.png';
  }

  String toIconPath() {
    return 'images/resources/fur_64.png';
  }

  Fur([value]) : super(value);
}

class IronOre extends ResourceType {
  String localizedKey = 'resources.ore';
  String localizedDescriptionKey = 'resources.oreDescription';
  RESOURCE_TYPES type = RESOURCE_TYPES.IRON_ORE;

  String toImagePath() {
    return 'images/resources/iron_ore.png';
  }

  String toIconPath() {
    return 'images/resources/iron_ore_64.png';
  }

  IronOre([value]) : super(value);
}
