import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/doc_generator/doc_generator_app.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/app_preferences.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_buildings/city_buildings_page.dart';
import 'package:sloboda/views/city_dashboard.dart';
import 'package:sloboda/views/components/CityBuilder.dart';
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
    return CityBuilder(
      city: city,
      builder: (context) {
        return InheritedCity(
          city: city,
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Column(
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
                                      if (tab == SlobodaLocalizations.events)
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
                        backgroundColor: Theme.of(context).backgroundColor,
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TitleText(city.name),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    LocaleSelection(
                                      locale: SlobodaLocalizations.locale,
                                      onLocaleChanged: (Locale locale) {
                                        setState(() {
                                          SlobodaLocalizations.locale = locale;
                                        });
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(SlobodaLocalizations
                                          .appVersionNumber),
                                    ),
                                  ],
                                ),
                                TitleText(
                                  city.name,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SoftContainer(
                                    child: StockFullView(
                                      stock: city.stock,
                                      stockSimulation: city.simulateStock(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _makeTurn(context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FullWidth(
                                    child: PressedInContainer(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ButtonText(
                                              SlobodaLocalizations.reset),
                                        ),
                                      ),
                                      onPress: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            CreateSlobodaView.routeName,
                                            (route) => false);
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FullWidth(
                                    child: PressedInContainer(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ButtonText(SlobodaLocalizations
                                              .documentationLabel),
                                        ),
                                      ),
                                      onPress: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            DocGeneratorApp.routeName,
                                            (route) => false);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
//                        physics: kIsWeb
//                            ? NeverScrollableScrollPhysics()
//                            : BouncingScrollPhysics(),
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
                  child: FullWidth(
                    child: _makeTurn(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _makeTurn(BuildContext context) {
    var city = widget.city;
    return PressedInContainer(
      onPress: () {
        city.makeTurn();
        AppPreferences.instance.saveSloboda(city.toJson());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ButtonText(
            SlobodaLocalizations.makeTurn,
          ),
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
