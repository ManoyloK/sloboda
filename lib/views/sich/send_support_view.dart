import 'package:flutter/material.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/models/app_preferences.dart';
import 'package:sloboda/models/sich_connector.dart';

import '../../components/button_text.dart';
import '../../components/divider.dart';
import '../../components/full_width_container.dart';
import '../../models/city_properties.dart';
import '../../models/resources/resource.dart';
import '../../models/sloboda.dart';
import '../../models/sloboda_localizations.dart';
import '../city_props_view.dart';
import '../components/soft_container.dart';
import '../resource_view.dart';

class SendSupportView extends StatefulWidget {
  final Sloboda city;

  SendSupportView({this.city});

  @override
  _SendSupportViewState createState() => _SendSupportViewState();
}

class _SendSupportViewState extends State<SendSupportView> {
  final SichConnector sich = SichConnector();
  int _amountOfCossackToSend = 10;
  int _amountOfGoldToSend = 10;

  @override
  Widget build(BuildContext context) {
    var hasCossacks =
        widget.city.props.getByType(CITY_PROPERTIES.COSSACKS) >= 1;
    var hasMonehy = widget.city.stock.getByType(RESOURCE_TYPES.MONEY) >= 1;
    return SoftContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FullWidth(
              child: PressedInContainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ButtonText(SlobodaLocalizations.sendCossacksToSich),
                  ),
                ),
                onPress: hasCossacks
                    ? () async {
                        try {
                          var hasEnough = widget.city.hasEnoughProp(
                              CityCossacks(_amountOfCossackToSend));
                          if (hasEnough) {
                            final result = await sich.sendCossacks(
                                _amountOfCossackToSend, widget.city.name);
                            if (result) {
                              widget.city
                                  .removeCossacks(_amountOfCossackToSend);
                              await AppPreferences.instance
                                  .saveSloboda(widget.city.toJson());
                            }
                          } else {
                            final snackBar = SnackBar(
                                content:
                                    Text('Not enough cossacks to be sent'));
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        } catch (e) {
                          print('Error while sending cossacks: $e');
                        }
                        setState(() {});
                      }
                    : null,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<int>(
                value: 1,
                groupValue: _amountOfCossackToSend,
                onChanged: (int value) {
                  setState(() {
                    _amountOfCossackToSend = value;
                  });
                },
              ),
              CityPropsMiniView(
                showLabels: false,
                props: CityProps(
                  values: {
                    CITY_PROPERTIES.COSSACKS: 1,
                  },
                ),
              ),
              Radio<int>(
                value: 10,
                groupValue: _amountOfCossackToSend,
                onChanged: (int value) {
                  setState(() {
                    _amountOfCossackToSend = value;
                  });
                },
              ),
              CityPropsMiniView(
                showLabels: false,
                props: CityProps(
                  values: {
                    CITY_PROPERTIES.COSSACKS: 10,
                  },
                ),
              ),
            ],
          ),
          VDivider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FullWidth(
              child: PressedInContainer(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ButtonText(SlobodaLocalizations.sendMoneyToSich),
                  ),
                ),
                onPress: hasMonehy
                    ? () async {
                        var hasEnough = widget.city
                            .hasEnoughStock(Money(_amountOfGoldToSend));
                        if (hasEnough) {
                          final result = await sich.sendMoney(
                              _amountOfGoldToSend, widget.city.name);
                          if (result) {
                            widget.city.removeFromStock(
                                {RESOURCE_TYPES.MONEY: _amountOfGoldToSend});
                            await AppPreferences.instance
                                .saveSloboda(widget.city.toJson());
                          }
                        } else {
                          final snackBar = SnackBar(
                              content: Text('Not enough cossacks to be sent'));
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                        setState(() {});
                      }
                    : null,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<int>(
                value: 1,
                groupValue: _amountOfGoldToSend,
                onChanged: (int value) {
                  setState(() {
                    _amountOfGoldToSend = value;
                  });
                },
              ),
              ResourceImageView(
                type: Money(),
                amount: 1,
              ),
              Radio<int>(
                value: 10,
                groupValue: _amountOfGoldToSend,
                onChanged: (int value) {
                  setState(() {
                    _amountOfGoldToSend = value;
                  });
                },
              ),
              ResourceImageView(
                type: Money(),
                amount: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
