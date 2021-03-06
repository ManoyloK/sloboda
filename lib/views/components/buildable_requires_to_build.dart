import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/abstract/buildable.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/compared_stock_view.dart';
import 'package:sloboda/views/resource_view.dart';

class BuildableRequiredToBuildView extends StatelessWidget {
  const BuildableRequiredToBuildView({
    Key key,
    @required this.building,
  }) : super(key: key);

  final Buildable building;

  @override
  Widget build(BuildContext context) {
    var city = InheritedCity.of(context).city;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TitleText(SlobodaLocalizations.requiredToBuildBy),
        StockComparedView<RESOURCE_TYPES>(
          first: Stock(values: building.requiredToBuild),
          second: city.stock,
          imageResolver: resourceImageResolver,
        ),
      ],
    );
  }
}
