import 'package:sloboda/models/abstract/stock_item.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/stock.dart';

class SLTask {
  SLTarget target;
  String localizedKey;
  String localizedDescriptionKey;
  String iconPath;

  static SLTask fromJson(Map<String, dynamic> jsonMap) {
    SLTask task = SLTask()
      ..localizedKey = jsonMap["localizedKey"]
      ..localizedDescriptionKey = jsonMap["localizedDescriptionKey"]
      ..target = SLTarget.fromJson(jsonMap["target"])
      ..iconPath = jsonMap["iconPath"];
    return task;
  }

  SLActiveTask toActiveTask(int amount) {
    SLActiveTask activeTask = SLActiveTask()
      ..localizedKey = localizedKey
      ..localizedDescriptionKey = localizedDescriptionKey
      ..target = target
      ..iconPath = iconPath
      ..progress = amount;

    return activeTask;
  }
}

class SLTarget {
  String type;
  int amount;
  String localizedKey;

  StockItem toInstanceType() {
    if (localizedKey.contains('cityProps')) {
      return CityProp.fromKey(localizedKey, amount);
    } else if (localizedKey.contains('resources')) {
      return ResourceType.fromKey(localizedKey, amount);
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
        result.localizedKey = jsonMap['localizedKey'];
        return result;
      case 'Money':
        var result = SLTargetMoney();
        result.amount = jsonMap['amount'];
        result.type = jsonMap['type'];
        result.localizedKey = jsonMap['localizedKey'];
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
    SLTask task = SLTask.fromJson(jsonMap);
    return task.toActiveTask(jsonMap['progress']);
  }
}
