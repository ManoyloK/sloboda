import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sloboda/animations/slideable_button.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_buildings/city_buildings_page.dart';
import 'package:sloboda/views/city_dashboard.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/create_sloboda.dart';
import 'package:sloboda/views/events_view.dart';
import 'package:sloboda/views/locale_selection.dart';
import 'package:sloboda/views/resource_buildings/resource_buildings_page.dart';
import 'package:sloboda/views/stock_view.dart';

class CityGame extends StatefulWidget {
  static const routeName = "/city_game";

  final Sloboda city;

  CityGame({this.city});

  @override
  _CityGameState createState() => _CityGameState();
}

typedef List<String> GenerateTitles();

class _CityGameState extends State<CityGame>
    with SingleTickerProviderStateMixin {
  GenerateTitles _pageTitles = () => [
        SlobodaLocalizations.overview,
        SlobodaLocalizations.events,
        SlobodaLocalizations.resources,
        SlobodaLocalizations.cityBuildings,
      ];

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: _pageTitles().length,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var city = widget.city;
    return StreamBuilder(
      stream: city.changes,
      builder: (context, snapshot) {
        return InheritedCity(
          city: city,
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: StreamBuilder(
                stream: city.changes,
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: DefaultTabController(
                          length: 4,
                          child: Scaffold(
                            appBar: AppBar(
                              bottom: TabBar(
                                controller: _tabController,
                                tabs: _pageTitles()
                                    .map(
                                      (tab) => Tab(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Text(
                                              tab,
                                            ),
                                            if (tab ==
                                                SlobodaLocalizations.events)
                                              Text(
                                                city.pendingNextEvents.length
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              title: StockMiniView(
                                stock: city.stock,
                                stockSimulation: city.simulateStock(),
                              ),
                            ),
                            drawer: Drawer(
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                color: Theme.of(context).backgroundColor,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      VDivider(),
                                      LocaleSelection(
                                        locale: SlobodaLocalizations.locale,
                                        onLocaleChanged: (Locale locale) {
                                          setState(() {
                                            SlobodaLocalizations.locale =
                                                locale;
                                          });
                                        },
                                      ),
                                      TitleText(
                                        city.name,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SoftContainer(
                                          child: StockFullView(
                                            stock: city.stock,
                                            stockSimulation:
                                                city.simulateStock(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SoftContainer(
                                          child: _makeTurn(context),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SoftContainer(
                                          child: FullWidth(
                                            child: FlatButton(
                                              child: Text(
                                                  SlobodaLocalizations.reset),
                                              onPressed: () {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        CreateSlobodaView
                                                            .routeName,
                                                        (route) => false);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            body: TabBarView(
                              physics: kIsWeb
                                  ? NeverScrollableScrollPhysics()
                                  : BouncingScrollPhysics(),
                              controller: _tabController,
                              children: <Widget>[
                                CityDashboard(city: city),
                                EventsView(
                                  events: city.events,
                                ),
                                ResourceBuildingsPage(),
                                CityBuildingsPage(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 24.0,
                        ),
                        child: SoftContainer(
                          child: FullWidth(
                            child: _makeTurn(context),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        );
      },
    );
  }

  Widget _makeTurn(BuildContext context) {
    var city = widget.city;
    return SoftContainer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SlideableButton(
          direction: Direction.Left,
          child: Center(
            child: ButtonText(
              SlobodaLocalizations.makeTurn,
            ),
          ),
          onPress: () {
            city.makeTurn();
          },
        ),
      ),
    );
  }
}

class CityGameArguments {
  final Sloboda city;

  CityGameArguments({this.city});
}

class ExtractCityGameArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final CityGameArguments args = ModalRoute.of(context).settings.arguments;

    return CityGame(
      city: args.city,
    );
  }
}

enum DialogAnswer { YES, NO }
