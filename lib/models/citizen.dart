import 'package:sloboda/extensions/list.dart';

class Citizen {
  var assignedTo;
  String name;

  void free() {
    assignedTo = null;
  }

  Citizen({fullName}) {
    if (fullName == null) {
      name = _generateName();
    } else {
      name = fullName;
    }
  }

  get occupied {
    return assignedTo != null;
  }

  String _generateName() {
    return '${firstNames.takeRandom()} ${lastName.takeRandom()}';
  }

  static getIconPath() {
    return 'images/city_buildings/citizen_64.png';
  }

  factory Citizen.fromJson(Map<String, dynamic> json) {
    return Citizen(fullName: json["name"]);
  }

  Map<String, dynamic> toJson() {
    return {"name": name};
  }
}

List firstNames = [
  'Тишко',
  'Федір',
  'Кіндрат',
  'Семен',
  'Гринько',
  'Луцик',
  'Андрій',
  'Дмитро',
  'Іван',
  'Клим',
  'Павло',
  'Яцько',
  'Мишко',
  'Тарас',
  'Іван',
  'Кіндрат',
  'Ігнат',
  'Ничіпор',
];
List lastName = [
  'Смілий',
  'Бублик',
  'Косиць',
  'Дорош',
  'Безпояско',
  'Ященко',
  'Ревко',
  'Карп',
  'Клименко',
  'Сметрик',
  'Скорик',
  'Адаменко',
  'Павленко',
  'Скоробагаченко',
  'Красненко',
  'Пилипенко',
  'Царенко',
  'Голоденко',
  'Задорожний'
];
