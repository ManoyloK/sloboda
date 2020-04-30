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
                    List<SLTask> availableTasks = snapshot.data[0];
                    List<SLActiveTask> activeTasks = snapshot.data[1];

                    return CityBuilder(
                      city: widget.city,
                      builder: (context) => SingleChildScrollView(
                        child: Center(
                          child: Column(
                            children: [
                              TitleText("Active tasks"),
                              Column(
                                children: activeTasks
                                    .map(
                                      (task) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SoftContainer(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SichTaskView(
                                                task: task,
                                                onRegisterPress: () {
                                                  _registerSlobodaForTask(
                                                      task.name);
                                                },
                                              )),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              VDivider(),
                              Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TitleText("Available tasks"),
                                ),
                                ...availableTasks
                                    .map(
                                      (task) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SoftContainer(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SichTaskView(
                                                task: task,
                                                onRegisterPress: () {
                                                  _registerSlobodaForTask(
                                                      task.name);
                                                },
                                              )),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ])
                            ],
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
                    child: Text(SlobodaLocalizations.readingTasks),
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
    List<SLTask> availableTasks = result[0];
    List<SLActiveTask> activeTasks = result[1];
    return [
      _getNotTakenTasks(availableTasks, activeTasks),
      _getActiveTasks(availableTasks, activeTasks),
    ];
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
