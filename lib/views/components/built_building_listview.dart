import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';

class BuiltBuildingListItem extends StatelessWidget {
  final VoidCallback onPress;
  final String buildingIconPath;
  final String title;
  final String producesIconPath;
  final int amount;

  BuiltBuildingListItem(
      {this.onPress,
      @required this.buildingIconPath,
      @required this.title,
      @required this.producesIconPath,
      this.amount = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            buildingIconPath,
            height: 64,
          ),
          TitleText(
            title,
          ),
          Row(
            children: <Widget>[
              Image.asset(
                producesIconPath,
                height: 32,
              ),
              Text(
                ' $amount',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              HDivider(),
              Image.asset(
                'images/ui/arrow_right.png',
                height: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
