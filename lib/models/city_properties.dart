import 'package:sloboda/models/abstract/stock_item.dart';
import 'package:sloboda/models/abstract/stockable.dart';

enum CITY_PROPERTIES { FAITH, DEFENSE, GLORY, CITIZENS, COSSACKS }

String cityPropertiesToString(CITY_PROPERTIES prop) {
  switch (prop) {
    case CITY_PROPERTIES.FAITH:
      return "FAITH";
    case CITY_PROPERTIES.DEFENSE:
      return "DEFENSE";
    case CITY_PROPERTIES.GLORY:
      return "GLORY";
    case CITY_PROPERTIES.CITIZENS:
      return "CITIZENS";
    case CITY_PROPERTIES.COSSACKS:
      return "COSSACKS";
    default:
      throw "City property $prop is not recognized.";
  }
}

CITY_PROPERTIES stringToCityProperties(String prop) {
  switch (prop) {
    case "FAITH":
      return CITY_PROPERTIES.FAITH;
    case "DEFENSE":
      return CITY_PROPERTIES.DEFENSE;
    case "GLORY":
      return CITY_PROPERTIES.GLORY;
    case "CITIZENS":
      return CITY_PROPERTIES.CITIZENS;
    case "COSSACKS":
      return CITY_PROPERTIES.COSSACKS;
    default:
      throw "City property $prop is not recognized.";
  }
}

abstract class CityProp extends StockItem<CITY_PROPERTIES> {
  static StockItem<CITY_PROPERTIES> fromType(CITY_PROPERTIES type,
      [int value]) {
    switch (type) {
      case CITY_PROPERTIES.FAITH:
        return CityFaith(value);
      case CITY_PROPERTIES.GLORY:
        return CityGlory(value);
      case CITY_PROPERTIES.DEFENSE:
        return CityDefense(value);
      case CITY_PROPERTIES.CITIZENS:
        return CityCitizens(value);
      case CITY_PROPERTIES.COSSACKS:
        return CityCossacks(value);
      default:
        throw 'Type $type is not recognized';
    }
  }

  static StockItem<CITY_PROPERTIES> fromKey(String type, [int value]) {
    switch (type) {
      case "cityProps.faith":
        return CityFaith(value);
      case "cityProps.glory":
        return CityGlory(value);
      case "cityProps.defense":
        return CityDefense(value);
      case "cityProps.citizens":
        return CityCitizens(value);
      case "cityProps.cossacks":
        return CityCossacks(value);
      default:
        throw 'Type $type is not recognized';
    }
  }

  CityProp([value]) : super(value);
}

class CityFaith extends CityProp {
  String localizedKey = 'cityProps.faith';
  String localizedDescriptionKey = 'cityProps.faithDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.FAITH;

  String toImagePath() {
    return 'images/city_props/faith.png';
  }

  String toIconPath() {
    return 'images/city_props/faith_64.png';
  }

  CityFaith([value]) : super(value);
}

class CityGlory extends CityProp {
  String localizedKey = 'cityProps.glory';
  String localizedDescriptionKey = 'cityProps.gloryDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.GLORY;

  String toImagePath() {
    return 'images/city_props/glory.png';
  }

  String toIconPath() {
    return 'images/city_props/glory_64.png';
  }

  CityGlory([value]) : super(value);
}

class CityDefense extends CityProp {
  String localizedKey = 'cityProps.defense';
  String localizedDescriptionKey = 'cityProps.defenseDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.DEFENSE;

  String toImagePath() {
    return 'images/city_props/defense.png';
  }

  String toIconPath() {
    return 'images/city_props/defense_64.png';
  }

  CityDefense([value]) : super(value);
}

class CityCitizens extends CityProp {
  String localizedKey = 'cityProps.citizens';
  String localizedDescriptionKey = 'cityProps.citizensDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.CITIZENS;

  String toImagePath() {
    return 'images/city_props/citizen.png';
  }

  String toIconPath() {
    return 'images/city_props/citizen_64.png';
  }

  CityCitizens([value]) : super(value);
}

class CityCossacks extends CityProp {
  String localizedKey = 'cityProps.cossacks';
  String localizedDescriptionKey = 'cityProps.cossacksDescription';
  CITY_PROPERTIES type = CITY_PROPERTIES.COSSACKS;

  String toImagePath() {
    return 'images/city_props/cossack.png';
  }

  String toIconPath() {
    return 'images/city_props/cossack_64.png';
  }

  CityCossacks([value]) : super(value);
}

class CityProps extends Stockable<CITY_PROPERTIES> {
  static const Map<CITY_PROPERTIES, int> defaultValues = {
    CITY_PROPERTIES.GLORY: 1,
    CITY_PROPERTIES.DEFENSE: 1,
    CITY_PROPERTIES.CITIZENS: 15,
    CITY_PROPERTIES.FAITH: 1,
    CITY_PROPERTIES.COSSACKS: 0,
  };

  CityProps({Map<CITY_PROPERTIES, int> values}) : super(values);

  static CityProps defaultProps() {
    return CityProps(values: defaultValues);
  }

  static CityProps bigProps() {
    return CityProps(values: {
      CITY_PROPERTIES.CITIZENS: 300,
      CITY_PROPERTIES.GLORY: 150,
      CITY_PROPERTIES.FAITH: 150,
      CITY_PROPERTIES.DEFENSE: 150,
      CITY_PROPERTIES.COSSACKS: 150,
    });
  }

  Map<String, dynamic> toJson() {
    var keys = values.keys;
    Map<String, dynamic> result = {};
    for (var key in keys) {
      result[cityPropertiesToString(key)] = values[key];
    }

    return result;
  }

  static fromJson(Map<String, dynamic> json) {
    var keys = json.keys;
    Map<CITY_PROPERTIES, int> values = {};
    for (var key in keys) {
      values[stringToCityProperties(key)] = json[key];
    }
    return CityProps(values: values);
  }
}
