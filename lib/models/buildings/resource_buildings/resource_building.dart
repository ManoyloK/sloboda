import 'package:sloboda/doc_generator/markdown_generator.dart';
import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/buildings/resource_buildings/field.dart';
import 'package:sloboda/models/buildings/resource_buildings/hunting_house.dart';
import 'package:sloboda/models/buildings/resource_buildings/iron_mine.dart';
import 'package:sloboda/models/buildings/resource_buildings/mill.dart';
import 'package:sloboda/models/buildings/resource_buildings/powder_cellar.dart';
import 'package:sloboda/models/buildings/resource_buildings/quarry.dart';
import 'package:sloboda/models/buildings/resource_buildings/smith.dart';
import 'package:sloboda/models/buildings/resource_buildings/stables.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';

abstract class ResourceBuilding
    with Producible
    implements Buildable<RESOURCE_TYPES>, MarkdownConvertible {
  Map<RESOURCE_TYPES, int> requiredToBuild;

  RESOURCE_BUILDING_TYPES type;
  int workMultiplier = 1;
  Map<RESOURCE_TYPES, int> requires = Map();
  String localizedKey;
  String localizedDescriptionKey;

  ResourceBuilding();

  MarkdownDocument toMarkDownDocument() {
    Stock stockRequiresToBuild = Stock(values: requiredToBuild);
    Stock stockRequires = Stock(values: requires);
    MarkdownDocument doc = MarkdownDocument();
    MarkdownDocument image = MarkdownDocument().image(
        toIconPath(), SlobodaLocalizations.getForKey(localizedKey), true);
    doc.h1(image.toString())
      ..text(toLocalizedDescriptionString())
      ..h3(SlobodaLocalizations.requiredToBuildBy)
      ..text(stockRequiresToBuild.toMarkDownDocument().toString())
      ..h3(SlobodaLocalizations.output)
      ..text(produces.toMarkDownDocument().toString())
      ..h3(SlobodaLocalizations.requiredForProductionBy)
      ..text(stockRequires.toMarkDownDocument().toString())
      ..point(MarkdownDocument()
          .h3('${SlobodaLocalizations.maxNumberOfWorkers}: ${maxWorkers}')
          .toString());

    return doc;
  }

  static MarkdownDocument toMarkDownFullDocs() {
    MarkdownDocument doc =
        MarkdownDocument().h1(SlobodaLocalizations.resources).separator();
    RESOURCE_BUILDING_TYPES.values.forEach((type) {
      var instance = ResourceBuilding.fromType(type);
      doc.text(instance.toMarkDownDocument().toString())
        ..separator()
        ..separator();
    });
    return doc;
  }

  static ResourceBuilding fromType(RESOURCE_BUILDING_TYPES type) {
    switch (type) {
      case RESOURCE_BUILDING_TYPES.FIELD:
        return Field();
      case RESOURCE_BUILDING_TYPES.MILL:
        return Mill();
      case RESOURCE_BUILDING_TYPES.QUARRY:
        return Quarry();
      case RESOURCE_BUILDING_TYPES.SMITH:
        return Smith();
      case RESOURCE_BUILDING_TYPES.STABLES:
        return Stables();
      case RESOURCE_BUILDING_TYPES.IRON_MINE:
        return IronMine();
      case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE:
        return TrapperHouse();
      case RESOURCE_BUILDING_TYPES.POWDER_CELLAR:
        return PowderCellar();
      default:
        throw 'Resource Type not Recognized';
    }
  }

  String toLocalizedString() {
    return SlobodaLocalizations.getForKey(localizedKey);
  }

  String toLocalizedDescriptionString() {
    return SlobodaLocalizations.getForKey(localizedDescriptionKey);
  }

  String toIconPath();

  String toImagePath();

  factory ResourceBuilding.fromJson(Map<String, dynamic> json) {
    var assignedHumans = Producible.assignedHumansFromJson(json);
    var type = stringToResourceBuildingType(json["type"]);
    var instance = ResourceBuilding.fromType(type)
      ..assignedHumans = assignedHumans;
    return instance;
  }

  Map<String, dynamic> toJson() {
    var map = super.partialMap();
    map["type"] = resourceBuildingTypeToString(type);
    return map;
  }
}

String resourceBuildingTypeToString(RESOURCE_BUILDING_TYPES type) {
  switch (type) {
    case RESOURCE_BUILDING_TYPES.SMITH:
      return "SMITH";
    case RESOURCE_BUILDING_TYPES.FIELD:
      return "FIELD";
    case RESOURCE_BUILDING_TYPES.MILL:
      return "MILL";
    case RESOURCE_BUILDING_TYPES.QUARRY:
      return "QUARRY";
    case RESOURCE_BUILDING_TYPES.STABLES:
      return "STABLES";
    case RESOURCE_BUILDING_TYPES.IRON_MINE:
      return "IRON_MINE";
    case RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE:
      return "TRAPPER_HOUSE";
    case RESOURCE_BUILDING_TYPES.POWDER_CELLAR:
      return "POWDER_CELLAR";
    default:
      throw "Resource building type $type is not recognized";
  }
}

RESOURCE_BUILDING_TYPES stringToResourceBuildingType(String type) {
  switch (type) {
    case "SMITH":
      return RESOURCE_BUILDING_TYPES.SMITH;
    case "FIELD":
      return RESOURCE_BUILDING_TYPES.FIELD;
    case "MILL":
      return RESOURCE_BUILDING_TYPES.MILL;
    case "QUARRY":
      return RESOURCE_BUILDING_TYPES.QUARRY;
    case "STABLES":
      return RESOURCE_BUILDING_TYPES.STABLES;
    case "IRON_MINE":
      return RESOURCE_BUILDING_TYPES.IRON_MINE;
    case "TRAPPER_HOUSE":
      return RESOURCE_BUILDING_TYPES.TRAPPER_HOUSE;
    case "POWDER_CELLAR":
      return RESOURCE_BUILDING_TYPES.POWDER_CELLAR;
    default:
      throw "Resource building type $type is not recognized";
  }
}

enum RESOURCE_BUILDING_TYPES {
  SMITH,
  FIELD,
  MILL,
  QUARRY,
  STABLES,
  IRON_MINE,
  TRAPPER_HOUSE,
  POWDER_CELLAR
}

class BuildingFull implements Exception {
  String cause;

  BuildingFull(this.cause);
}
