import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:sloboda/extensions/int.dart';
import 'package:sloboda/extensions/list.dart';
import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/buildings/city_buildings/city_building.dart';
import 'package:sloboda/models/buildings/city_buildings/house.dart';
import 'package:sloboda/models/buildings/resource_buildings/nature_resource.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/events/random_choicable_events.dart';
import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/seasons.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';

class Sloboda {
  String name;
  int foundedYear = 1550;
  int currentYear = 1550;
  CitySeason currentSeason = WinterSeason();
  List<CityBuilding> cityBuildings = [House()];
  List<Citizen> citizens = [];

  List<ResourceBuilding> resourceBuildings = [];
  List<NaturalResource> naturalResources = [
    Forest(),
    River(),
  ];

  final List<CityEvent> events = [];
  final Queue<RandomTurnEvent> pendingNextEvents = Queue();
  bool disableRandomEvents;

  Stock stock;
  CityProps props;

  BehaviorSubject _innerChanges = BehaviorSubject();
  ValueStream changes;

  List<Function> _nextRandomEvents = [];

  Sloboda(
      {this.name, this.stock, this.props, this.disableRandomEvents = false}) {
    if (stock == null) {
      stock = Stock.defaultStock();
    }
    if (props == null) {
      props = CityProps.defaultProps();
    }

    var citizensCount = props.getByType(CITY_PROPERTIES.CITIZENS);
    citizensCount.timesRepeat(() => citizens.add(Citizen()));

    changes = _innerChanges.stream;

    for (var nr in naturalResources) {
      nr.changes.stream.listen(_buildingChangesListener);
    }

    for (var rb in resourceBuildings) {
      rb.changes.stream.listen(_buildingChangesListener);
    }
  }

  _buildingChangesListener(event) {
    _innerChanges.add(this);
  }

  bool hasFreeCitizens() {
    return citizens.where((citizen) => !citizen.occupied).length > 0;
  }

  removeFromStock(Map<RESOURCE_TYPES, int> map) {
    map.entries.forEach((e) {
      stock.removeFromType(e.key, e.value);
    });
    _innerChanges.add(this);
  }

  hasEnoughProp(CityProp prop) {
    final existing = props.getByType(prop.type);
    return existing >= prop.value;
  }

  hasEnoughStock(ResourceType type) {
    final existing = stock.getByType(type.type);
    return existing >= type.value;
  }

  removeCossacks(int amount) {
    final existing = props.getByType(CITY_PROPERTIES.COSSACKS);
    if (existing < amount) {
      throw 'Not enough cossacks to send';
    } else {
      props.removeFromType(CITY_PROPERTIES.COSSACKS, amount);
    }
    _innerChanges.add(this);
  }

  buildBuilding(Buildable buildable) {
    if (canBuildResourceBuilding(buildable)) {
      removeFromStock(buildable.requiredToBuild);
      if (buildable is ResourceBuilding) {
        resourceBuildings.add(buildable);
        Producible producible = buildable;
        producible.changes.stream.listen(_buildingChangesListener);
      } else if (buildable is CityBuilding) {
        cityBuildings.add(buildable);
      }
      _innerChanges.add(this);
    }
  }

  bool canBuildResourceBuilding(Buildable b) {
    var required = b.requiredToBuild;
    Map<String, int> missing = {};
    required.entries.forEach((r) {
      if (r.value > stock.getByType(r.key)) {
        missing[ResourceType.fromType(r.key).toLocalizedString()] =
            r.value - stock.getByType(r.key);
      }
    });

    if (missing.isEmpty) {
      return true;
    } else {
      throw MissingResources(missing);
    }
  }

  Citizen getFirstFreeCitizen() {
    var free = citizens.where((citizen) => !citizen.occupied).toList();
    if (free.isEmpty) {
      throw 'No free citizens';
    } else {
      return free[0];
    }
  }

  List<Citizen> getAllFreeCitizens() {
    return citizens.where((citizen) => !citizen.occupied).toList();
  }

  void removeResourceBuilding(ResourceBuilding building) {
    resourceBuildings.remove(building);
    building.destroy();
    _innerChanges.add(this);
  }

  void removeCityBuilding(CityBuilding building) {
    cityBuildings.remove(building);
    _innerChanges.add(this);
  }

  void _runAttachedEvents() {
    for (var _event in _nextRandomEvents) {
      EventMessage event = _event();
      this.stock + event.stock;
      this.addProps(event.cityProps);
      if (event.cityProps != null) {
        final includesCitizens =
            event.cityProps.getByType(CITY_PROPERTIES.CITIZENS);
        if (includesCitizens != null) {
          if (includesCitizens > 0) {
            this.addCitizens(
                amount: event.cityProps.getByType(CITY_PROPERTIES.CITIZENS));
          } else {
            this.removeCitizens(amount: includesCitizens);
          }
        }
      }
      events.add(
        CityEvent(
          season: currentSeason,
          sourceEvent: event,
          yearHappened: currentYear,
        ),
      );
    }

    _nextRandomEvents.clear();
  }

  List<RandomTurnEvent> getChoicableRandomEvents() {
    final List _events = RandomTurnEvent.allEvents.where((event) {
      return event is ChoicableRandomTurnEvent && event.canHappen(this);
    }).toList();

    return _events;
  }

  void addChoicableEventWithAnswer(bool yes, ChoicableRandomTurnEvent event) {
    events.add(
      CityEvent(
        season: currentSeason.previous,
        yearHappened:
            currentSeason is WinterSeason ? currentYear - 1 : currentYear,
        sourceEvent: EventMessage(
          stock: null,
          event: event,
          messageKey: event.choiceToStringKey(yes),
        ),
      ),
    );

    if (yes) {
      runChoicableEventResult(event);
    }

    pendingNextEvents.remove(event);

    _innerChanges.add(this);
  }

  void runChoicableEventResult(ChoicableRandomTurnEvent event) {
    Function f = event.makeChoice(true, this);
    _nextRandomEvents.add(f);
  }

  void removeCitizens({amount}) {
    for (var i = 0; i < amount; i++) {
      final c = citizens.takeRandom();
      c.free();
      citizens.remove(c);
    }

    _innerChanges.add(this);
  }

  void addCitizens({amount = 1}) {
    for (var i = 0; i < amount; i++) {
      citizens.add(Citizen());
    }

    _innerChanges.add(this);
  }

  void addProps(CityProps aProps) {
    props + aProps;
    _innerChanges.add(this);
  }

  _cleanPendingEvents() {
    pendingNextEvents.clear();
  }

  void makeTurn() {
    _runAttachedEvents();
    _cleanPendingEvents();

    List<Exception> exceptions = [];
    simulateStock();
    List<Producible> list = [...naturalResources, ...resourceBuildings];

    list.forEach((resBuilding) {
      try {
        resBuilding.generate(stock);
      } catch (e) {
        exceptions.add(e);
      }
    });

    _innerChanges.add(this);
    for (var exception in exceptions) {
      if (exception is NotEnoughWorkers) {
        events.add(
          CityEvent(
            sourceEvent: EventMessage(
              event: null,
              messageKey: SlobodaLocalizations.getForKey(
                      exception.building.localizedKey) +
                  ' ' +
                  exception.cause,
            ),
            yearHappened: currentYear,
            season: currentSeason,
          ),
        );
      }
      if (exception is NotEnoughResourcesException) {
        events.add(
          CityEvent(
            sourceEvent: EventMessage(
              event: null,
              messageKey: SlobodaLocalizations.getForKey(
                      exception.building.localizedKey) +
                  ' ' +
                  SlobodaLocalizations.getForKey(exception.localizedKey) +
                  ' ' +
                  exception.amount.toString() +
                  ' ' +
                  exception.resource.toLocalizedString(),
            ),
            yearHappened: currentYear,
            season: currentSeason,
          ),
        );
      }
    }

    cityBuildings.forEach((cb) {
      Map<CITY_PROPERTIES, int> generated = cb.generate();
      generated.entries.forEach((e) {
        if (e.key == CITY_PROPERTIES.CITIZENS) {
          e.value.timesRepeat(() {
            citizens.add(Citizen());
          });
        }
        props.addToType(e.key, e.value);
      });
    });

    if (!disableRandomEvents) {
      // generate random events
      try {
        final _events = RandomTurnEvent.allEvents.where((event) {
          return event.canHappen(this) && !(event is ChoicableRandomTurnEvent);
        });

        for (var event in _events) {
          if (event != null) {
            EventMessage eventResult = event.execute(this)();
            this.stock + eventResult.stock;
            events.add(
              CityEvent(
                sourceEvent: eventResult,
                yearHappened: currentYear,
                season: currentSeason,
              ),
            );
          }
        }
      } catch (e) {
        print(e);
      }
    }

    _queueNextEvents();
    _moveToNextSeason();
  }

  _queueNextEvents() {
    List<RandomTurnEvent> choicableEvents =
        getChoicableRandomEvents().take(3).toList();
    pendingNextEvents.addAll(choicableEvents);
  }

  _moveToNextSeason() {
    currentSeason = nextSeason(currentSeason);
    if (currentSeason is WinterSeason) {
      currentYear++;
    }
  }

  Map<CITY_PROPERTIES, int> simulateCityProps() {
    Map<CITY_PROPERTIES, int> newMap =
        cityBuildings.fold(props.asMap(), (Map value, cb) {
      var prod = cb.produces;
      if (value.containsKey(prod)) {
        value[prod.type] += cb.produces.value;
      } else {
        value[prod.type] = props.getByType(prod.type);
      }
      return value;
    });

    return newMap;
  }

  Stock simulateStock() {
    List<Producible> list = [...naturalResources, ...resourceBuildings];

    Map<RESOURCE_TYPES, int> requires = list.fold({}, (Map value, building) {
      var req = building.requires.map((k, v) {
        return MapEntry(
            k, v * building.amountOfWorkers() * building.workMultiplier);
      });

      req.entries.forEach((element) {
        if (value.containsKey(element.key)) {
          value[element.key] += element.value;
        } else {
          value[element.key] = element.value;
        }
      });
      return value;
    });

    Map<RESOURCE_TYPES, int> produces = list.fold({}, (Map value, building) {
      if (value.containsKey(building.produces.type)) {
        value[building.produces.type] +=
            building.workMultiplier * building.amountOfWorkers();
      } else {
        value[building.produces.type] =
            building.workMultiplier * building.amountOfWorkers();
      }

      return value;
    });

    Map<RESOURCE_TYPES, int> newStock = Map();
    RESOURCE_TYPES.values.forEach((type) {
      if (!newStock.containsKey(type)) {
        newStock[type] = 0;
      }
      if (!produces.containsKey(type)) {
        produces[type] = 0;
      }
      if (!requires.containsKey(type)) {
        requires[type] = 0;
      }
      try {
        newStock[type] =
            produces[type] - requires[type] + stock.getByType(type);
      } catch (e) {
        print(e);
      }
    });
    return Stock(values: newStock);
  }

  CitySeason nextSeason(CitySeason currentSeason) {
    switch (currentSeason.runtimeType) {
      case (SpringSeason):
        return SummerSeason();
      case (SummerSeason):
        return AutumnSeason();
      case (AutumnSeason):
        return WinterSeason();
      case (WinterSeason):
        return SpringSeason();
      default:
        return SpringSeason();
    }
  }

  factory Sloboda.fromJson(Map<String, dynamic> json) {
    Sloboda city = new Sloboda(name: json["name"])
      ..currentYear = json["currentYear"]
      ..foundedYear = json["foundedYear"]
      ..currentSeason = CitySeason.fromJson(json["currentSeason"])
      ..cityBuildings = (json["cityBuildings"] as List)
          .map((json) => CityBuilding.fromJson(json as Map<String, dynamic>))
          .toList() as List<CityBuilding>;
    return city;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "currentYear": currentYear,
      "foundedYear": foundedYear,
      "currentSeason": currentSeason.toJson(),
      "cityBuildings": cityBuildings.map((cb) => cb.toJson()).toList()
    };
  }

  void dispose() {
    _innerChanges.close();
  }
}

class MissingResources implements Exception {
  final Map<String, int> causes;

  MissingResources(this.causes);

  String toLocalizedString() {
    return causes.entries
        .map((c) {
          return '${SlobodaLocalizations.getForKey(c.key)}: ${c.value}';
        })
        .toList()
        .toString();
  }
}
