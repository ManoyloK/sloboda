import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/rotatable_image.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/city_event.dart';
import 'package:sloboda/models/events/random_choicable_events.dart';
import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_props_view.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

Map<String, List<CityEvent>> foldEvents(List<CityEvent> events) {
  Map<String, List<CityEvent>> result = {};

  for (final e in events) {
    if (result.containsKey(
        e.yearHappened.toString() + ',' + e.season.toLocalizedKey())) {
      result[e.yearHappened.toString() + ',' + e.season.toLocalizedKey()]
          .add(e);
    } else {
      result[e.yearHappened.toString() + ',' + e.season.toLocalizedKey()] = [e];
    }
  }

  return result;
}

class EventsView extends StatelessWidget {
  Map<String, List<CityEvent>> _events;

  EventsView({List events}) {
    _events = foldEvents(events);
  }

  Widget build(BuildContext context) {
    final city = InheritedCity.of(context).city;
    final Queue<RandomTurnEvent> pendingEvents = city.pendingNextEvents;
    return Column(
      children: <Widget>[
        if (pendingEvents.isNotEmpty)
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              child: PendingEventsView(
                events: pendingEvents,
              ),
            ),
          ),
        if (pendingEvents.isEmpty)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SoftContainer(
                child: ListView.separated(
                  itemCount: _events.keys.length,
                  separatorBuilder: (context, index) {
                    return VDivider();
                  },
                  itemBuilder: (context, index) {
                    final keysList = _events.keys.toList();
                    keysList.sort((a, b) {
                      var year1 = a.split(',')[0];
                      var year2 = b.split(',')[0];

                      return year1.compareTo(year2);
                    });
                    final key = keysList[keysList.length - 1 - index];
                    var seasonKey = key.split(',')[1];
                    var year = key.split(',')[0];
                    return SoftContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SoftContainer(
                              child: Container(
                                height: 40,
                                child: FullWidth(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TitleText(
                                        '${SlobodaLocalizations.getForKey(seasonKey)} ${year.toString()}'),
                                  ),
                                ),
                              ),
                            ),
                            ..._events[key].reversed.map((event) {
                              var textStyle;
                              if (city.currentSeason.isNextTo(event.season)) {
                                textStyle =
                                    Theme.of(context).textTheme.headline6;
                              }
                              return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SoftContainer(
                                    child: Column(
                                      children: <Widget>[
                                        if (event.sourceEvent.imagePath != null)
                                          Image.asset(
                                            event.sourceEvent.imagePath,
                                            width: 64,
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FullWidth(
                                            child: Text(
                                              SlobodaLocalizations.getForKey(
                                                  event.sourceEvent.messageKey),
                                              textAlign: TextAlign.center,
                                              style: textStyle,
                                            ),
                                          ),
                                        ),
                                        if (event.sourceEvent.stock != null)
                                          StockMiniView(
                                            stock: event.sourceEvent.stock,
                                            stockSimulation: null,
                                          ),
                                        if (event.sourceEvent.cityProps != null)
                                          CityPropsMiniView(
                                            props: event.sourceEvent.cityProps,
                                          ),
                                      ],
                                    ),
                                  ));
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class PendingEventsView extends StatefulWidget {
  final Queue<RandomTurnEvent> events;

  PendingEventsView({this.events});

  @override
  _PendingEventsViewState createState() => _PendingEventsViewState();
}

class _PendingEventsViewState extends State<PendingEventsView> {
  @override
  Widget build(BuildContext context) {
    ChoicableRandomTurnEvent event = widget.events.first;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SoftContainer(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RotatableImage(
              width: 320,
              imagePath: event.imagePath,
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              TitleText(
                SlobodaLocalizations.incomingEventLabel,
              ),
              SVDivider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  SlobodaLocalizations.getForKey(
                    event.localizedQuestionKey,
                  ),
                ),
              ),
            ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                PressedInContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.check),
                        TitleText(SlobodaLocalizations.yesToRandomEvent),
                      ],
                    ),
                  ),
                  onPress: () {
                    Sloboda city = InheritedCity.of(context).city;

                    city.addChoicableEventWithAnswer(true, event);
                  },
                ),
                SVDivider(),
                PressedInContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.skip_next),
                        TitleText(SlobodaLocalizations.noToRandomEvent),
                      ],
                    ),
                  ),
                  onPress: () {
                    Sloboda city = InheritedCity.of(context).city;
                    city.addChoicableEventWithAnswer(false, event);
                  },
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
