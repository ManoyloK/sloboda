import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/models/app_preferences.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/city_game.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/locale_selection.dart';

class CreateSlobodaView extends StatefulWidget {
  static String routeName = '/createSloboda';

  @override
  _CreateSlobodaViewState createState() => _CreateSlobodaViewState();
}

class _CreateSlobodaViewState extends State<CreateSlobodaView> {
  final AsyncMemoizer _appPreferencesInitter = AsyncMemoizer();

  _appPreferencesInit() {
    return _appPreferencesInitter.runOnce(() => AppPreferences.instance.init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _appPreferencesInit(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SoftContainer(
                        child: LocaleSelection(
                          locale: SlobodaLocalizations.locale,
                          onLocaleChanged: (Locale locale) {
                            setState(() {
                              SlobodaLocalizations.locale = locale;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SoftContainer(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > constraints.maxHeight) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: _buildChildren(context),
                                ),
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _buildChildren(context),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildChildren(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var imageWidth = width * 0.6;
    return [
      Expanded(
        flex: 15,
        child: SoftContainer(
          child: FullWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/city_props/citizen.png",
                  width: imageWidth,
                ),
                RaisedButton(
                  child: Text(SlobodaLocalizations.normalSloboda),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      CityGame.routeName,
                      arguments: CityGameArguments(
                        city: Sloboda(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: AllDivider(),
      ),
      Expanded(
        flex: 15,
        child: SoftContainer(
          child: FullWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "images/city_props/cossack.png",
                  width: imageWidth,
                ),
                RaisedButton(
                  child: Text(SlobodaLocalizations.bigSloboda),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      CityGame.routeName,
                      arguments: CityGameArguments(
                        city: Sloboda(
                          stock: Stock.bigStock(),
                          props: CityProps.bigProps(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
