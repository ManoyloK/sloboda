import 'package:flutter/material.dart';
import 'package:sloboda/models/city_properties.dart';
import 'package:sloboda/views/city_props_view.dart';

class CityPropertyImageView extends StatelessWidget {
  final CityProp prop;
  final int amount;
  CityPropertyImageView({this.prop, this.amount});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: prop.toLocalizedString(),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            CityPropScreen.routeName,
            arguments: CityPropScreenArguments(
              prop: prop,
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              prop.toImagePath(),
              width: 64,
            ),
            if (amount != null)
              Text(
                ' $amount',
                style: Theme.of(context).textTheme.bodyText2,
              ),
          ],
        ),
      ),
    );
  }
}
