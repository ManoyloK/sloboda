import 'package:sloboda/models/citizen.dart';
import 'package:test/test.dart';

void main() {
  group("Citizen tests", () {
    var citizen = Citizen();
    test("(de)serialization with generated name", () {
      var newCitizen = Citizen.fromJson(citizen.toJson());
      expect(newCitizen.name, equals(citizen.name));
    });

    test("(de)serialization with fullName", () {
      citizen.name = "Dima";
      var newCitizen = Citizen.fromJson(citizen.toJson());
      expect(newCitizen.name, equals("Dima"));
    });
  });
}
