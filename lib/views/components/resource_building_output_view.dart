import 'package:flutter/widgets.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/abstract/producable.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/compared_stock_view.dart';
import 'package:sloboda/views/resource_view.dart';

class ResourceBuildingOutputView extends StatelessWidget {
  const ResourceBuildingOutputView({
    Key key,
    @required this.building,
  }) : super(key: key);

  final Producible building;

  @override
  Widget build(BuildContext context) {
    Stock stock = Stock(
      values: {building.produces.type: building.outputAmount},
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(SlobodaLocalizations.output),
        StockComparedView(
          first: stock,
          second: InheritedCity.of(context).city.stock,
          imageResolver: resourceImageResolver,
        )
      ],
    );
  }
}
