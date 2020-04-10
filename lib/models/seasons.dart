abstract class CitySeason {
  CITY_SEASONS get type;

  set type(t) {
    throw 'Type cannot be changed';
  }

  String toLocalizedKey();

  CitySeason();

  factory CitySeason.fromJson(Map<String, dynamic> json) {
    switch (json["type"]) {
      case "SUMMER":
        return SummerSeason();
      case "WINTER":
        return WinterSeason();
      case "AUTUMN":
        return AutumnSeason();
      case "SPRING":
        return SpringSeason();
    }
  }

  Map<String, dynamic> toJson() {
    switch (runtimeType) {
      case (SpringSeason):
        return {"type": "SPRING"};
      case (SummerSeason):
        return {"type": "SUMMER"};
      case (AutumnSeason):
        return {"type": "AUTUMN"};
      case (WinterSeason):
        return {"type": "WINTER"};
    }
  }

  bool isNextTo(CitySeason another) {
    switch (runtimeType) {
      case (SpringSeason):
        return another is WinterSeason;
      case (SummerSeason):
        return another is SpringSeason;
      case (AutumnSeason):
        return another is SummerSeason;
      case (WinterSeason):
        return another is AutumnSeason;
      default:
        return false;
    }
  }

  CitySeason get next {
    throw 'Must implement';
  }

  CitySeason get previous {
    throw 'Must implement';
  }
}

class WinterSeason extends CitySeason {
  CITY_SEASONS get type {
    return CITY_SEASONS.WINTER;
  }

  String toLocalizedKey() {
    return 'winter';
  }

  CitySeason get next {
    return SpringSeason();
  }

  CitySeason get previous {
    return AutumnSeason();
  }
}

class SpringSeason extends CitySeason {
  CITY_SEASONS get type {
    return CITY_SEASONS.SPRING;
  }

  String toLocalizedKey() {
    return 'spring';
  }

  CitySeason get next {
    return SummerSeason();
  }

  CitySeason get previous {
    return WinterSeason();
  }
}

class SummerSeason extends CitySeason {
  CITY_SEASONS get type {
    return CITY_SEASONS.SUMMER;
  }

  String toLocalizedKey() {
    return 'summer';
  }

  CitySeason get next {
    return AutumnSeason();
  }

  CitySeason get previous {
    return SpringSeason();
  }
}

class AutumnSeason extends CitySeason {
  CITY_SEASONS get type {
    return CITY_SEASONS.AUTUMN;
  }

  String toLocalizedKey() {
    return 'autumn';
  }

  CitySeason get next {
    return WinterSeason();
  }

  CitySeason get previous {
    return SummerSeason();
  }
}

enum CITY_SEASONS { AUTUMN, WINTER, SPRING, SUMMER }
