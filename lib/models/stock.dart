import 'package:sloboda/doc_generator/markdown_generator.dart';
import 'package:sloboda/models/abstract/stockable.dart';
import 'package:sloboda/models/resources/resource.dart';

class Stock extends Stockable<RESOURCE_TYPES> implements MarkdownConvertible {
  static const Map<RESOURCE_TYPES, int> defaultValues = {
    RESOURCE_TYPES.FOOD: 20,
    RESOURCE_TYPES.FIREARM: 1,
    RESOURCE_TYPES.WOOD: 15,
    RESOURCE_TYPES.STONE: 15,
    RESOURCE_TYPES.IRON_ORE: 1,
    RESOURCE_TYPES.MONEY: 0,
    RESOURCE_TYPES.HORSE: 5,
    RESOURCE_TYPES.POWDER: 5,
    RESOURCE_TYPES.FUR: 0,
    RESOURCE_TYPES.FISH: 0,
  };

  Stock({Map<RESOURCE_TYPES, int> values}) : super(values);
  static defaultStock() {
    return Stock(values: defaultValues);
  }

  static Stock bigStock() {
    return Stock(values: {
      RESOURCE_TYPES.FOOD: 500,
      RESOURCE_TYPES.FIREARM: 150,
      RESOURCE_TYPES.WOOD: 500,
      RESOURCE_TYPES.STONE: 300,
      RESOURCE_TYPES.IRON_ORE: 100,
      RESOURCE_TYPES.MONEY: 500,
      RESOURCE_TYPES.HORSE: 150,
      RESOURCE_TYPES.POWDER: 200,
      RESOURCE_TYPES.FUR: 50,
      RESOURCE_TYPES.FISH: 50,
    });
  }

  Map<String, dynamic> toJson() {
    var keys = values.keys;
    Map<String, dynamic> result = {};
    for (var key in keys) {
      result[resourceTypesToString(key)] = values[key];
    }

    return result;
  }

  static fromJson(Map<String, dynamic> json) {
    var keys = json.keys;
    Map<RESOURCE_TYPES, int> values = {};
    for (var key in keys) {
      values[stringToResourceType(key)] = json[key];
    }
    return Stock(values: values);
  }

  MarkdownDocument toMarkDownDocument() {
    MarkdownDocument doc = MarkdownDocument();
    values.forEach((key, value) {
      ResourceType resource = ResourceType.fromType(key, value);
      doc.point(resource.toMarkDownDocument().toString());
    });
    return doc;
  }
}
