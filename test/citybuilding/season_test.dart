import 'package:sloboda/models/seasons.dart';
import 'package:test/test.dart';

void main() {
  group("Can (de)serialize Seasons", () {
    test("Summer", () {
      var summer = SummerSeason();
      var map = summer.toJson();
      var newSummer = CitySeason.fromJson(map);
      expect(summer.type, equals(newSummer.type));
    });

    test("Winter", () {
      var season = WinterSeason();
      var map = season.toJson();
      var newSeason = CitySeason.fromJson(map);
      expect(season.type, equals(newSeason.type));
    });

    test("Autumn", () {
      var season = AutumnSeason();
      var map = season.toJson();
      var newSeason = CitySeason.fromJson(map);
      expect(season.type, equals(newSeason.type));
    });

    test("Spring", () {
      var season = SpringSeason();
      var map = season.toJson();
      var newSeason = CitySeason.fromJson(map);
      expect(season.type, equals(newSeason.type));
    });
  });
}
