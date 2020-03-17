import 'package:flutter/foundation.dart';
import 'package:sloboda/models/events/random_turn_events.dart';

class CityEvent {
  final int yearHappened;
  final CitySeason season;
  final EventMessage sourceEvent;

  CityEvent({this.yearHappened, this.season, @required this.sourceEvent});

  static CityEvent copyFrom(CityEvent event) {
    return CityEvent(
      yearHappened: event.yearHappened,
      season: event.season,
      sourceEvent: event.sourceEvent,
    );
  }
}

abstract class CitySeason {
  CITY_SEASONS get type;

  set type(t) {
    throw 'Type cannot be changed';
  }

  String toLocalizedKey();

  CitySeason();

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
