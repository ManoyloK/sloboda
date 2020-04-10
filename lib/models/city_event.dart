import 'package:flutter/foundation.dart';
import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:sloboda/models/seasons.dart';

class CityEvent {
  final int yearHappened;
  final CitySeason season;
  final EventMessage sourceEvent;

  CityEvent({this.yearHappened, this.season, @required this.sourceEvent});

  static CityEvent copyFrom(CityEvent event) {
    return CityEvent(
      yearHappened: event.yearHappened,
      season: event.season,
      sourceEvent: event.sourceEvent,
    );
  }
}
