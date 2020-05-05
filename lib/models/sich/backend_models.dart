import 'package:sloboda/models/abstract/stock_item.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/stock.dart';

class SLTask {
  String name;
  String description;
  SLTarget target;

  static SLTask fromJson(Map<String, dynamic> jsonMap) {
    SLTask task = SLTask()
      ..name = jsonMap["name"]
      ..description = jsonMap["description"]
      ..target = SLTarget.fromJson(jsonMap["target"]);

    return task;
  }
}

class SLTarget {
  String type;
  int amount;
  String localizedNameKey;

  StockItem toInstanceType() {
    if (localizedNameKey.contains('cityProps')) {
      return CityProp.fromKey(localizedNameKey, amount);
    } else if (localizedNameKey.contains('resources')) {
      return ResourceType.fromKey(localizedNameKey, amount);
    }
  }

  toStock() {
    var item = toInstanceType();
    if (item is CityProp) {
      CityProps props = CityProps(
        values: {item.type: amount},
      );
      return props;
    } else if (item is ResourceType) {
      return Stock(
        values: {item.type: amount},
      );
    }
  }

  static SLTarget fromJson(Map<String, dynamic> jsonMap) {
    switch (jsonMap['type']) {
      case 'Cossacks':
        var result = SLTargetCossacks();
        result.amount = jsonMap['amount'];
        result.type = jsonMap['type'];
        result.localizedNameKey = jsonMap['localizedNameKey'];
        return result;
      case 'Money':
        var result = SLTargetMoney();
        result.amount = jsonMap['amount'];
        result.type = jsonMap['type'];
        result.localizedNameKey = jsonMap['localizedNameKey'];
        return result;
    }
  }
}

class SLTargetCossacks extends SLTarget {}

class SLTargetMoney extends SLTarget {}

class SLSloboda {
  String name;
  int money;
  int cossacks;
  List<SLActiveTask> activeTasks = [];
  int completedTaskCount;

  static SLSloboda fromJson(Map<String, dynamic> jsonMap) {
    SLSloboda sloboda = SLSloboda()
      ..name = jsonMap['name']
      ..money = jsonMap['money']
      ..cossacks = jsonMap['cossacks']
      ..activeTasks = (jsonMap['activeTasks'] as List)
          .map((jsonActiveTask) => SLActiveTask.fromJson(jsonActiveTask))
          .toList()
      ..completedTaskCount = jsonMap['completedTaskCount'];
    return sloboda;
  }
}

class SLActiveTask extends SLTask {
  int progress;

  static SLActiveTask fromJson(Map<String, dynamic> jsonMap) {
    SLActiveTask task = SLActiveTask()
      ..name = jsonMap["name"]
      ..description = jsonMap["description"]
      ..target = SLTarget.fromJson(jsonMap["target"])
      ..progress = jsonMap['progress'];

    return task;
  }
}
