import 'package:rxdart/rxdart.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/citizen.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';

class Producible {
  BehaviorSubject changes = BehaviorSubject();
  ResourceType produces;
  Map<RESOURCE_TYPES, int> requires = Map();
  List<Citizen> assignedHumans = [];
  int maxWorkers = 30;
  int workMultiplier = 1;

  get outputAmount => workMultiplier * assignedHumans.length;

  bool hasWorkers() {
    return assignedHumans.isNotEmpty;
  }

  int amountOfWorkers() {
    return assignedHumans.length;
  }

  bool isFull() {
    return maxWorkers == assignedHumans.length;
  }

  bool isEmpty() {
    return assignedHumans.length == 0;
  }

  void addWorker(Citizen citizen) {
    if (citizen.occupied) {
      return;
    }

    if (maxWorkers < assignedHumans.length + 1) {
      throw BuildingFull('Building is at maximum capacity: $maxWorkers');
    }
    assignedHumans.add(citizen);
    citizen.assignedTo = this;

    changes.add(this);
  }

  void addWorkers(List<Citizen> citizens) {
    for (var citizen in citizens) {
      if (!citizen.occupied) {
        addWorker(citizen);
      }
    }
  }

  Citizen removeWorker(Citizen h) {
    assignedHumans.remove(h);
    if (h != null) {
      h.free();
    }

    changes.add(this);

    return h;
  }

  void generate(Stock stock) {
    if (!hasWorkers()) {
      throw NotEnoughWorkers(
        building: this,
        cause: SlobodaLocalizations.hasNoAssignedWorkers,
      );
    }

    if (requires.entries.length > 0) {
      var executors = [];
      // check if stock satisfies the required input
      for (var reqRes in requires.entries) {
        var inStock = stock.getByType(reqRes.key) ?? 0;
        var requiredToProduce =
            reqRes.value * assignedHumans.length * workMultiplier;
        if (requiredToProduce > inStock) {
          throw NotEnoughResourcesException(
            building: this,
            amount: requiredToProduce - inStock,
            resource: ResourceType.fromType(reqRes.key),
          );
        } else {
          executors.add(() {
            stock.removeFromType(reqRes.key, requiredToProduce);
          });
        }
      }

      // no exception was thrown, we can execute the stock
      executors.forEach((executor) => executor());
    }
    stock.addToType(produces.type, assignedHumans.length * workMultiplier);
  }

  void destroy() {
    assignedHumans.forEach((citizen) => citizen.free());
    changes.close();
  }

  String get localizedKey {
    throw 'Must Implement';
  }

  static assignedHumansFromJson(Map<String, dynamic> json) {
    return (json["assignedHumans"] as List)
        .map((humanJson) => Citizen.fromJson(humanJson))
        .toList();
  }

  Map<String, dynamic> partialMap() {
    return {"assignedHumans": assignedHumans.map((h) => h.toJson()).toList()};
  }
}

class NotEnoughResourcesException implements Exception {
  final int amount;
  final ResourceType resource;
  final Producible building;

  final String localizedKey = 'notEnoughResources';

  NotEnoughResourcesException({this.amount, this.building, this.resource});
}

class NotEnoughWorkers implements Exception {
  String cause;
  Producible building;

  NotEnoughWorkers({this.cause, this.building});
}
