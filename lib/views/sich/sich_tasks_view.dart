import 'package:flutter/material.dart';
import 'package:sloboda/animations/pressed_in_container.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/models/sich/backend_models.dart';
import 'package:sloboda/models/sich_connector.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/CityBuilder.dart';
import 'package:sloboda/views/components/soft_container.dart';

class SichTasksScreen extends StatefulWidget {
  static String routeName = '/sich_tasks';
  final Sloboda city;

  SichTasksScreen({this.city});

  @override
  _SichTasksScreenState createState() => _SichTasksScreenState();
}

class _SichTasksScreenState extends State<SichTasksScreen> {
  final SichConnector sichConnector = SichConnector();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _updateDataFromBackend(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<SLTask> tasksList = snapshot.data[0];
                    return CityBuilder(
                      city: widget.city,
                      builder: (context) => SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: tasksList
                                .map(
                                  (task) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SoftContainer(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            TitleText(
                                              SlobodaLocalizations.getForKey(
                                                  task.name),
                                            ),
                                            Text(
                                              SlobodaLocalizations.getForKey(
                                                  task.description),
                                            ),
                                            VDivider(),
                                            TitleText(
                                                "${SlobodaLocalizations.getForKey(task.target.localizedNameKey)}: ${task.target.amount}"),
                                            PressedInContainer(
                                              child: TitleText('Register'),
                                              onPress: () {
                                                _registerSlobodaForTask(
                                                    task.name);
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Text("No tasks available"),
                  );
                default:
                  return Center(
                    child: Text('Reading tasks'),
                  );
              }
            },
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

  Future _registerSlobodaForTask(String taskName) async {
    await sichConnector.registerTaskForSloboda(widget.city.name, taskName);
    setState(() {});
  }

  Future _updateDataFromBackend() async {
    List<Future> futures = [_fetchAvailableTasks(), _fetchActiveTasks()];

    List result = await Future.wait(futures);

    return result;
  }

  Future _fetchAvailableTasks() async {
    return await sichConnector.readAvailableTasks();
  }

  Future _fetchActiveTasks() async {
    return await sichConnector.readSlobodaActiveTasks(widget.city.name);
  }
}

class SichTasksScreenArguments {
  final Sloboda city;

  SichTasksScreenArguments({this.city});
}

class ExtractSichTasksScreenArguments extends StatelessWidget {
  Widget build(BuildContext context) {
    final SichTasksScreenArguments args =
        ModalRoute.of(context).settings.arguments;

    return SichTasksScreen(
      city: args.city,
    );
  }
}
