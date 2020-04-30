import 'package:flutter/material.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/sich/backend_models.dart';
import 'package:sloboda/models/sloboda_localizations.dart';

class SichTaskView extends StatefulWidget {
  final SLTask task;
  final VoidCallback onRegisterPress;

  SichTaskView({@required this.task, @required this.onRegisterPress});

  @override
  _SichTaskViewState createState() => _SichTaskViewState();
}

class _SichTaskViewState extends State<SichTaskView> {
  @override
  Widget build(BuildContext context) {
    var task = widget.task;
    return Column(
      children: [
        TitleText(
          SlobodaLocalizations.getForKey(task.name),
        ),
        Text(
          SlobodaLocalizations.getForKey(task.description),
        ),
        VDivider(),
        TitleText(
          "${SlobodaLocalizations.getForKey(task.target.localizedNameKey)}: ${task.target.amount}",
        ),
        VDivider(),
        PressedInContainer(
          child: FullWidth(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TitleText(SlobodaLocalizations.registerTask),
          )),
          onPress: () {
            widget.onRegisterPress();
          },
        )
      ],
    );
  }
}
