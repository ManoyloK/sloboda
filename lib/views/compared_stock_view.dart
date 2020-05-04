import 'package:flutter/material.dart';
import 'package:sloboda/extensions/list.dart';
import 'package:sloboda/models/abstract/stockable.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/models/resources/resource.dart';
import 'package:sloboda/views/components/lined_container.dart';

typedef Widget ImageWidgetResolverByStockableType<T>(T key);

class StockComparedView<T> extends StatelessWidget {
  final Stockable first;
  final Stockable second;
  final ImageWidgetResolverByStockableType<T> imageResolver;

  StockComparedView({
    @required this.first,
    @required this.second,
    @required this.imageResolver,
  });

  List _getValues() {
    if (T == RESOURCE_TYPES) {
      return RESOURCE_TYPES.values.where((value) {
        return first.values.keys.contains(value);
      }).toList();
    } else {
      return CITY_PROPERTIES.values.where((value) {
        return first.values.keys.contains(value);
      }).toList();
    }
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
                            imageResolver(key),
                            Text(first.getByType(key).toString()),
                            Text("/"),
                            Text(second.getByType(key).toString()),
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
