import 'package:flutter/material.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/extensions/list.dart';
import 'package:sloboda/models/sich/backend_models.dart';
import 'package:sloboda/models/sich_connector.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/CityBuilder.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/sich/sich_task_view.dart';

class SichTasksScreen extends StatefulWidget {
  static String routeName = '/sich_tasks';
  final Sloboda city;

  SichTasksScreen({this.city});

  @override
  _SichTasksScreenState createState() => _SichTasksScreenState();
}

class _SichTasksScreenState extends State<SichTasksScreen> {
  final SichConnector sichConnector = SichConnector();
  List<SLActiveTask> activeTasks = [];
  List<SLTask> availableTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _updateDataFromBackend(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: TitleText('Failed to read data from Sich'),
                  ),
                );
              }

              return CityBuilder(
                city: widget.city,
                builder: (context) => SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        TitleText(SlobodaLocalizations.activeTasks),
                        Column(
                          children: activeTasks
                              .map(
                                (task) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SoftContainer(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SichTaskView(
                                          task: task,
                                          onRegisterPress: () {
                                            _registerSlobodaForTask(task.name);
                                          },
                                        )),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        VDivider(),
                        TitleText(SlobodaLocalizations.availableTasks),
                        Column(
                          children: availableTasks
                              .map(
                                (task) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SoftContainer(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SichTaskView(
                                          task: task,
                                          onRegisterPress: () {
                                            _registerSlobodaForTask(task.name);
                                          },
                                        )),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
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
    this.availableTasks = _getNotTakenTasks(result[0], result[1]);
    this.activeTasks = _getActiveTasks(result[0], result[1]);
  }

  List<SLActiveTask> _getActiveTasks(
      List<SLTask> availableTasks, List<SLActiveTask> activeTasks) {
    List<SLActiveTask> result = activeTasks.intersection<SLActiveTask, SLTask>(
        availableTasks, (a, b) => (a.name == b.name));
    return result;
  }

  List<SLTask> _getNotTakenTasks(
      List<SLTask> availableTasks, List<SLActiveTask> activeTasks) {
    List notTakenTasks =
        availableTasks.rest<SLTask, SLActiveTask>(activeTasks, (a, b) {
      return (a.name == b.name);
    });
    return notTakenTasks;
  }

  Future<List<SLTask>> _fetchAvailableTasks() async {
    return await sichConnector.readAvailableTasks();
  }

  Future<List<SLActiveTask>> _fetchActiveTasks() async {
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
