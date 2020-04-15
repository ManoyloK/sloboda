import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/events/random_choicable_events.dart';
import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/seasons.dart';
import 'package:sloboda/models/stock.dart';
import 'package:test/test.dart';

void main() {
  group("CityEvent tests", () {
    var cityEvent = CityEvent(
        yearHappened: 1000,
        season: AutumnSeason(),
        sourceEvent: EventMessage(
          messageKey: "messageKey",
          stock: Stock(values: {RESOURCE_TYPES.STONE: 5}),
          cityProps: CityProps(values: {CITY_PROPERTIES.FAITH: 10}),
          imagePath: "123",
          event: KoshoviyPohid(),
        ));

    test("Can (de)serialize", () {
      var newCityEvent = CityEvent.fromJson(cityEvent.toJson());
      expect(newCityEvent.yearHappened, equals(cityEvent.yearHappened));
      expect(newCityEvent.season, isA<AutumnSeason>());
      expect(newCityEvent.sourceEvent, isNotNull);
    });
  });
}
