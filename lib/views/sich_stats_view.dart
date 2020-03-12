import 'package:flutter/material.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sich_connector.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/city_props_view.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/stock_view.dart';

import '../models/sich_connector.dart';

class SichStatsView extends StatefulWidget {
  final Sloboda city;

  SichStatsView({@required this.city});

  @override
  _SichStatsViewState createState() => _SichStatsViewState();
}

class _SichStatsViewState extends State<SichStatsView> {
  final SichConnector sich = SichConnector();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SoftContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: sich.readStats(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Text('Failed to read data'),
                  );
                }
                var cossacks = snapshot.hasData ? snapshot.data['cossacks'] : 0;
                var gold = snapshot.hasData ? snapshot.data['money'] : 0;
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TitleText(
                        SlobodaLocalizations.sichHas,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CityPropsMiniView(
                            props: CityProps(
                              values: {
                                CITY_PROPERTIES.COSSACKS: cossacks,
                              },
                            ),
                          ),
                          StockMiniView(
                            stock: Stock(
                              values: {
                                RESOURCE_TYPES.MONEY: gold,
                              },
                            ),
                            stockSimulation: null,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
