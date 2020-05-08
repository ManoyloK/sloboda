import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/doc_generator/doc_generator_app.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/app_preferences.dart';
import 'package:sloboda/models/buildings/city_buildings/church.dart';
import 'package:sloboda/models/buildings/shooting_range.dart';
import 'package:sloboda/models/events/random_turn_events.dart';
import 'package:sloboda/models/resources/resource.dart';
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

bool _isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 640.0;
}

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
        SlobodaLocalizations.settingsLabel,
      ];

  TabController _tabController;

  int _selectedIndex = 0;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: _pageTitles().length - 1,
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
            appBar: _isMediumScreen(context)
                ? AppBar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    title: StockMiniView(
                      stock: city.stock,
                      stockSimulation: city.simulateStock(),
                    ),
                  )
                : null,
            body: _isMediumScreen(context)
                ? navigationRail(context, city)
                : _smallScreenView(context, city),
          ),
        );
      },
    );
  }

  Widget navigationRail(BuildContext context, Sloboda city) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 9,
          child: Row(
            children: [
              NavigationRail(
                backgroundColor: Theme.of(context).backgroundColor,
                extended: false,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: Image.asset(ShootingRange().icon, color: Colors.grey),
                    selectedIcon: Image.asset(
                      ShootingRange().icon,
                    ),
                    label: Text(_pageTitles()[0]),
                  ),
                  NavigationRailDestination(
                    icon: Image.asset(MerchantVisit().iconPath,
                        color: Colors.grey),
                    selectedIcon: Image.asset(MerchantVisit().iconPath),
                    label: Text(
                      '${_pageTitles()[1]} (${city.pendingNextEvents.length})',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Image.asset(
                      Food().toIconPath(),
                      color: Colors.grey,
                    ),
                    selectedIcon: Image.asset(
                      Food().toIconPath(),
                    ),
                    label: Text(_pageTitles()[2]),
                  ),
                  NavigationRailDestination(
                    icon:
                        Image.asset(Church().toIconPath(), color: Colors.grey),
                    selectedIcon: Image.asset(Church().toIconPath()),
                    label: Text(_pageTitles()[3]),
                  ),
                  NavigationRailDestination(
                    icon: Image.asset('images/city_buildings/sich_64.png',
                        width: 64, color: Colors.grey),
                    selectedIcon: Image.asset(
                      'images/city_buildings/sich_64.png',
                      width: 64,
                    ),
                    label: Text(_pageTitles()[4]),
                  ),
                ],
              ),
              VerticalDivider(thickness: 1, width: 1),
              // This is the main content.
              Expanded(
                child: _getNavigationMainContent(
                  _selectedIndex,
                  context,
                  city,
                ),
              ),
            ],
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
    );
  }

  Widget _getNavigationMainContent(
      int index, BuildContext context, Sloboda city) {
    List<Widget> list = [
      CityDashboard(city: city),
      EventsView(
        events: city.events,
      ),
      ResourceBuildingsPage(),
      CityBuildingsPage(),
      _getSettingsView(context, city),
    ];

    return list[index];
  }

  Widget _getSettingsView(BuildContext context, Sloboda city) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
            child: TitleText(city.name),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                child: Text(SlobodaLocalizations.appVersionNumber),
              ),
            ],
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
            child: FullWidth(
              child: PressedInContainer(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonText(SlobodaLocalizations.reset),
                  ),
                ),
                onPress: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, CreateSlobodaView.routeName, (route) => false);
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
                    child: ButtonText(SlobodaLocalizations.documentationLabel),
                  ),
                ),
                onPress: () {
                  Navigator.pushNamed(context, DocGeneratorApp.routeName);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallScreenView(BuildContext context, Sloboda city) {
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
                      .take(4)
                      .map(
                        (tab) => Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                tab,
                              ),
                              if (tab == SlobodaLocalizations.events)
                                Text(
                                  city.pendingNextEvents.length.toString(),
                                  style: Theme.of(context).textTheme.headline6,
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
                  child: _getSettingsView(context, city),
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
