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
