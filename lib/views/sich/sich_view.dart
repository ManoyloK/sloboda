import 'package:flutter/material.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/button_text.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/rotatable_image.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/CityBuilder.dart';
import 'package:sloboda/views/sich/send_support_view.dart';
import 'package:sloboda/views/sich/sich_stats_view.dart';
import 'package:sloboda/views/sich/sich_tasks_view.dart';

import '../../components/divider.dart';

class SichScreen extends StatefulWidget {
  static String routeName = '/sich';
  final Sloboda city;

  SichScreen({this.city});

  @override
  _SichScreenState createState() => _SichScreenState();
}

class _SichScreenState extends State<SichScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CityBuilder(
        city: widget.city,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SichStatsView(
                          city: widget.city,
                        ),
                        VDivider(),
                        SendSupportView(
                          city: widget.city,
                        ),
                        VDivider(),
                        Hero(
                          tag: 'sich',
                          child: RotatableImage(
                            imagePaths: generateRotatableImagesFromImage(
                                'images/city_buildings/sich.png'),
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        VDivider(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: PressedInContainer(
                  child: FullWidth(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ButtonText(SlobodaLocalizations.sichTasks),
                      ),
                    ),
                  ),
                  onPress: () {
                    Navigator.pushNamed(
                      context,
                      SichTasksScreen.routeName,
                      arguments: SichTasksScreenArguments(city: widget.city),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: TitleText(
          SlobodaLocalizations.sichName,
        ),
      ),
    );
  }
}

class SichScreenArguments {
  final Sloboda city;

  SichScreenArguments({this.city});
}

class ExtractSichScreenArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final SichScreenArguments args = ModalRoute.of(context).settings.arguments;

    return SichScreen(
      city: args.city,
    );
  }
}
