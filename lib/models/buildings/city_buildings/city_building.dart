import 'package:sloboda/doc_generator/markdown_generator.dart';
import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/abstract/stock_item.dart';
import 'package:sloboda/models/buildings/city_buildings/church.dart';
import 'package:sloboda/models/buildings/city_buildings/house.dart';
import 'package:sloboda/models/buildings/city_buildings/tower.dart';
import 'package:sloboda/models/buildings/city_buildings/wall.dart';
import 'package:sloboda/models/buildings/city_buildings/watch_tower.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';

abstract class CityBuilding implements Buildable<RESOURCE_TYPES> {
  StockItem<CITY_PROPERTIES> produces;
  CITY_BUILDING_TYPES type;
  CityBuilding();
  static CityBuilding fromType(CITY_BUILDING_TYPES type) {
    switch (type) {
      case CITY_BUILDING_TYPES.CHURCH:
        return Church();
      case CITY_BUILDING_TYPES.HOUSE:
        return House();
      case CITY_BUILDING_TYPES.TOWER:
        return Tower();
      case CITY_BUILDING_TYPES.WATCH_TOWER:
        return WatchTower();
      case CITY_BUILDING_TYPES.WALL:
        return Wall();
      default:
        throw 'Building $type is not recognized';
    }
  }

  String localizedKey;
  String localizedDescriptionKey;

  String toIconPath() {
    throw UnimplementedError();
  }

  String toImagePath() {
    throw UnimplementedError();
  }

  Map<CITY_PROPERTIES, int> generate() {
    return Map.fromEntries([MapEntry(produces.type, produces.value)]);
  }

  factory CityBuilding.fromJson(Map<String, dynamic> json) {
    switch (json["type"]) {
      case "HOUSE":
        return House();
      case "CHURCH":
        return Church();
      case "TOWER":
        return Tower();
      case "WATCH_TOWER":
        return WatchTower();
      case "WALL":
        return Wall();
      default:
        throw "City building type ${json['type']} was not recognized";
    }
  }

  Map<String, dynamic> toJson();

  static MarkdownDocument toMarkDownFullDocs() {
    MarkdownDocument doc =
        MarkdownDocument().h1(SlobodaLocalizations.cityBuildings).separator();
    CITY_BUILDING_TYPES.values.forEach((type) {
      var instance = CityBuilding.fromType(type);
      doc.text(instance.toMarkDownDocument().toString())
        ..separator()
        ..separator();
    });
    return doc;
  }

  MarkdownDocument toMarkDownDocument() {
    Stock stockRequiresToBuild = Stock(values: requiredToBuild);
    MarkdownDocument doc = MarkdownDocument();
    MarkdownDocument image = MarkdownDocument().image(
        toIconPath(), SlobodaLocalizations.getForKey(localizedKey), true);
    doc.h1(image.toString())
      ..text(SlobodaLocalizations.getForKey(localizedKey))
      ..h3(SlobodaLocalizations.requiredToBuildBy)
      ..text(stockRequiresToBuild.toMarkDownDocument().toString())
      ..h3(SlobodaLocalizations.output)
      ..text(produces.toMarkDownDocument().toString());

    return doc;
  }
}

enum CITY_BUILDING_TYPES { HOUSE, CHURCH, TOWER, WATCH_TOWER, WALL }
