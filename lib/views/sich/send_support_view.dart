import 'package:flutter/material.dart';
import 'package:sloboda/models/sich_connector.dart';

import '../../animations/slideable_button.dart';
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
    return SoftContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FullWidth(
                  child: SlideableButton(
                      child: Center(
                        child:
                            ButtonText(SlobodaLocalizations.sendCossacksToSich),
                      ),
                      onPress: () async {
                        try {
                          widget.city.removeCossacks(_amountOfCossackToSend);
                          await sich.sendCossacks(_amountOfCossackToSend);
                        } catch (e) {
                          print('Error while sending cossacks: $e');
                        }
                        setState(() {});
                      }),
                ),
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
            child: SoftContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FullWidth(
                  child: SlideableButton(
                      child: Center(
                        child: ButtonText(SlobodaLocalizations.sendMoneyToSich),
                      ),
                      onPress: () async {
                        try {
                          widget.city.removeFromStock(
                            {
                              RESOURCE_TYPES.MONEY: _amountOfGoldToSend,
                            },
                          );
                          await sich.sendMoney(_amountOfGoldToSend);
                        } catch (e) {
                          print('Error while sending money: $e');
                        }
                        setState(() {});
                      }),
                ),
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
