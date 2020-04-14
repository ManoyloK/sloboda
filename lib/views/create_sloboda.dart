import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/app_preferences.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/city_game.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/locale_selection.dart';

class CreateSlobodaView extends StatefulWidget {
  static String routeName = '/';

  @override
  _CreateSlobodaViewState createState() => _CreateSlobodaViewState();
}

class _CreateSlobodaViewState extends State<CreateSlobodaView> {
  final AsyncMemoizer _appPreferencesInitter = AsyncMemoizer();
  final TextEditingController _textInputController = TextEditingController();

  _appPreferencesInit() {
    return _appPreferencesInitter.runOnce(() => AppPreferences.instance.init());
  }

  @override
  void initState() {
    _textInputController.text = 'Моя Слобода';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _appPreferencesInit(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var savedSlobodaJson = AppPreferences.instance.readSloboda();
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SoftContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              LocaleSelection(
                                locale: SlobodaLocalizations.locale,
                                onLocaleChanged: (Locale locale) {
                                  setState(() {
                                    SlobodaLocalizations.locale = locale;
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  Text(
                                    SlobodaLocalizations.labelInputSlobodaName,
                                  ),
                                  HDivider(),
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                      controller: _textInputController,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (savedSlobodaJson != null)
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: TitleText(
                                  SlobodaLocalizations.youHaveSavedGame),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              PressedInContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      ButtonText(SlobodaLocalizations.loadGame),
                                ),
                                onPress: () {
                                  Sloboda city =
                                      Sloboda.fromJson(savedSlobodaJson);
                                  Navigator.pushNamed(
                                    context,
                                    CityGame.routeName,
                                    arguments: CityGameArguments(
                                      city: city,
                                    ),
                                  );
                                },
                              ),
                              HDivider(),
                              PressedInContainer(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ButtonText(
                                      SlobodaLocalizations.deleteGame),
                                ),
                                onPress: () {
                                  AppPreferences.instance.removeSavedSloboda();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    flex: 5,
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
                                  children:
                                      _buildChildren(context, constraints),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children:
                                      _buildChildren(context, constraints),
                                ),
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

  _buildChildren(BuildContext context, BoxConstraints constraints) {
    var width = MediaQuery.of(context).size.width;
    var imageWidth = width * 0.5;
    var isInLandScape = constraints.maxWidth > constraints.maxHeight;
    return [
      Expanded(
        flex: 3,
        child: SoftContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/city_props/citizen.png",
                width: imageWidth,
              ),
              PressedInContainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonText(SlobodaLocalizations.normalSloboda),
                ),
                onPress: () {
                  Navigator.pushNamed(
                    context,
                    CityGame.routeName,
                    arguments: CityGameArguments(
                      city: Sloboda(name: _textInputController.text),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      isInLandScape ? HDivider() : VDivider(),
      Expanded(
        flex: 3,
        child: SoftContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/city_props/cossack.png",
                width: imageWidth,
              ),
              PressedInContainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonText(SlobodaLocalizations.bigSloboda),
                ),
                onPress: () {
                  Navigator.pushNamed(
                    context,
                    CityGame.routeName,
                    arguments: CityGameArguments(
                      city: Sloboda(
                        name: _textInputController.text,
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
    ];
  }
}
