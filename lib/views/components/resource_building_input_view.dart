import 'package:flutter/widgets.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/buildings/resource_buildings/resource_building.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/compared_stock_view.dart';
import 'package:sloboda/views/resource_view.dart';

class ResourceBuildingInputView extends StatelessWidget {
  const ResourceBuildingInputView({
    Key key,
    @required this.building,
  }) : super(key: key);

  final ResourceBuilding building;

  @override
  Widget build(BuildContext context) {
    var multiplier =
        building.amountOfWorkers() == 0 ? 1 : building.amountOfWorkers();

    Stock stock = Stock(values: building.requires);
    stock * multiplier;
    var city = InheritedCity.of(context).city;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TitleText(SlobodaLocalizations.input),
        StockComparedView<RESOURCE_TYPES>(
          first: stock,
          second: city.stock,
          imageResolver: resourceImageResolver,
        ),
      ],
    );
  }
}
