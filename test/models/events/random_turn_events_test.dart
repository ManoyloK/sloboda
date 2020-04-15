import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:test/test.dart';

void main() {
  group("RandomTurnEvent tests", () {
    test("Can (de)serialize TartarsRaid", () {
      TartarsRaid event = TartarsRaid();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<TartarsRaid>());
    });

    test("Can (de)serialize SaranaInvasion", () {
      SaranaInvasion event = SaranaInvasion();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<SaranaInvasion>());
    });

    test("Can (de)serialize ChildrenPopulation", () {
      ChildrenPopulation event = ChildrenPopulation();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<ChildrenPopulation>());
    });

    test("Can (de)serialize SteppeFire", () {
      SteppeFire event = SteppeFire();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<SteppeFire>());
    });

    test("Can (de)serialize RunnersFromSuppression", () {
      RunnersFromSuppression event = RunnersFromSuppression();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<RunnersFromSuppression>());
    });

    test("Can (de)serialize SettlersArrived", () {
      SettlersArrived event = SettlersArrived();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<SettlersArrived>());
    });

    test("Can (de)serialize GuestsFromSich", () {
      GuestsFromSich event = GuestsFromSich();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<GuestsFromSich>());
    });

    test("Can (de)serialize ChambulCapture", () {
      ChambulCapture event = ChambulCapture();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<ChambulCapture>());
    });

    test("Can (de)serialize MerchantVisit", () {
      MerchantVisit event = MerchantVisit();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<MerchantVisit>());
    });

    test("Can (de)serialize UniteWithNeighbours", () {
      UniteWithNeighbours event = UniteWithNeighbours();
      var newEvent = RandomTurnEvent.fromJson(event.toJson());

      expect(newEvent, isA<UniteWithNeighbours>());
    });

    test("All registered events have localizedKey setup", () {
      for (var event in RandomTurnEvent.allEvents) {
        expect(event.localizedKey, isNotNull);
      }
    });
  });
}
