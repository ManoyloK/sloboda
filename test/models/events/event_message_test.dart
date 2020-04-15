import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/events/random_choicable_events.dart';
import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/stock.dart';
import 'package:test/test.dart';

void main() {
  group("EventMessage tests", () {
    EventMessage event = EventMessage(
      messageKey: "messageKey",
      stock: Stock(values: {RESOURCE_TYPES.STONE: 5}),
      cityProps: CityProps(values: {CITY_PROPERTIES.FAITH: 10}),
      imagePath: "123",
      event: KoshoviyPohid(),
    );

    test("Can (de)serialize", () {
      EventMessage newEvent = EventMessage.fromJson(event.toJson());

      expect(newEvent.stock.getByType(RESOURCE_TYPES.STONE),
          equals(event.stock.getByType(RESOURCE_TYPES.STONE)));

      expect(newEvent.cityProps.getByType(CITY_PROPERTIES.FAITH),
          equals(event.cityProps.getByType(CITY_PROPERTIES.FAITH)));

      expect(newEvent.imagePath, equals(event.imagePath));

      expect(newEvent.event, isA<KoshoviyPohid>());
    });
  });
}
