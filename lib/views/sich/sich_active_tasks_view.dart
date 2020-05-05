import 'package:flutter/material.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/sich/backend_models.dart';
import 'package:sloboda/models/sich_connector.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/city_props_view.dart';
import 'package:sloboda/views/compared_stock_view.dart';
import 'package:sloboda/views/resource_view.dart';

class SichActiveTaskView extends StatefulWidget {
  final SLTask task;
  final VoidCallback onDoPress;

  SichActiveTaskView({@required this.task, @required this.onDoPress});

  @override
  _SichActiveTaskViewState createState() => _SichActiveTaskViewState();
}

class _SichActiveTaskViewState extends State<SichActiveTaskView> {
  @override
  Widget build(BuildContext context) {
    var task = widget.task;
    var isCityPropTarget = task.target.localizedNameKey.contains('cityProps');
    return Column(
      children: [
        TitleText(
          SlobodaLocalizations.getForKey(task.name),
        ),
        Text(
          SlobodaLocalizations.getForKey(task.description),
        ),
        VDivider(),
        if (isCityPropTarget)
          StockComparedView<CITY_PROPERTIES>(
            first: task.target.toStock(),
            second: InheritedCity.of(context).city.props,
            imageResolver: cityPropImageResolver,
          ),
        if (!isCityPropTarget)
          StockComparedView<RESOURCE_TYPES>(
            first: task.target.toStock(),
            second: InheritedCity.of(context).city.stock,
            imageResolver: resourceImageResolver,
          ),
        VDivider(),
        PressedInContainer(
          child: FullWidth(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TitleText(SlobodaLocalizations.completeTask),
            ),
          ),
          onPress: () async {
            Sloboda city = InheritedCity.of(context).city;
            var existing = city.getStockItem(task.target.toInstanceType());
            if (existing >= task.target.amount) {
              SLSloboda sloboda = await SichConnector()
                  .doTask(city.name, task.name, task.target.amount);
              if (sloboda != null) {
                city.removeStockItem(task.target.toInstanceType());
              }
            }
          },
        )
      ],
    );
  }
}
