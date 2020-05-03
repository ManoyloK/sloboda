import 'package:flutter/material.dart';
import 'package:sloboda/extensions/list.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/models/stock.dart';
import 'package:sloboda/views/components/lined_container.dart';
import 'package:sloboda/views/resource_view.dart';

class StockComparedView extends StatelessWidget {
  final Stock stock;
  final Stock stock2;

  StockComparedView({
    @required this.stock,
    @required this.stock2,
  });

  List<RESOURCE_TYPES> _getValues() {
    return RESOURCE_TYPES.values.where((value) {
      return stock.values.keys.contains(value);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ..._getValues().divideBy(2).map<Widget>(
              (List keys) {
                return LineContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: keys.map(
                      (key) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ResourceImageView(
                              type: ResourceType.fromType(key),
                            ),
                            Text(stock.getByType(key).toString()),
                            Text("/"),
                            Text(stock2.getByType(key).toString()),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}
