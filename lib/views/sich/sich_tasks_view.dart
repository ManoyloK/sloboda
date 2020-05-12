import 'package:flutter/material.dart';
import 'package:sloboda/components/divider.dart';
import 'package:sloboda/components/full_width_container.dart';
import 'package:sloboda/components/title_text.dart';
import 'package:sloboda/extensions/list.dart';
import 'package:sloboda/inherited_city.dart';
import 'package:sloboda/models/sich/backend_models.dart';
import 'package:sloboda/models/sich_connector.dart';
import 'package:sloboda/models/sloboda.dart';
import 'package:sloboda/models/sloboda_localizations.dart';
import 'package:sloboda/views/components/CityBuilder.dart';
import 'package:sloboda/views/components/soft_container.dart';
import 'package:sloboda/views/sich/sich_active_tasks_view.dart';
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
  SLSloboda sloboda = SLSloboda();
  List<SLTask> availableTasks = [];
  List<SLActiveTask> activeTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InheritedCity(
        city: widget.city,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CityBuilder(
              city: widget.city,
              builder: (context) => FutureBuilder(
                future: _updateDataFromBackend(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                      child: Center(
                        child: TitleText('Failed to read data from Sich'),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TitleText(
                              '${SlobodaLocalizations.doneTasksAmount}: ${sloboda.completedTaskCount}'),
                        ],
                      ),
                      VDivider(),
                      SoftContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            TitleText(SlobodaLocalizations.activeTasks),
                            ...sloboda.activeTasks.isNotEmpty
                                ? sloboda.activeTasks
                                    .map(
                                      (task) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SoftContainer(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SichActiveTaskView(
                                                task: task,
                                                onDoPress: () {
                                                  _registerSlobodaForTask(
                                                      task.localizedKey);
                                                },
                                              )),
                                        ),
                                      ),
                                    )
                                    .toList()
                                : [noAvailableTasks()],
                          ]),
                        ),
                      ),
                      VDivider(),
                      SoftContainer(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TitleText(SlobodaLocalizations.availableTasks),
                              ...availableTasks.isNotEmpty
                                  ? availableTasks
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
                                                        task.localizedKey);
                                                  },
                                                )),
                                          ),
                                        ),
                                      )
                                      .toList()
                                  : [
                                      noAvailableTasks(),
                                    ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: TitleText(
          SlobodaLocalizations.sichTasks,
        ),
      ),
    );
  }

  Widget noAvailableTasks() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SoftContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FullWidth(
            child: Center(child: Text("No available tasks")),
          ),
        ),
      ),
    );
  }

  Future _registerSlobodaForTask(String taskName) async {
    await sichConnector.registerTaskForSloboda(widget.city.name, taskName);
    setState(() {});
  }

  Future _updateDataFromBackend() async {
    List<Future> futures = [_fetchAvailableTasks(), _fetchSlobodaStats()];

    List result = await Future.wait(futures);
    sloboda = result[1];
    availableTasks = _getNotTakenTasks(result[0], sloboda.activeTasks);
    activeTasks = _getActiveTasks(result[0], sloboda.activeTasks);
  }

  List<SLActiveTask> _getActiveTasks(
      List<SLTask> availableTasks, List<SLActiveTask> activeTasks) {
    List<SLActiveTask> result = activeTasks.intersection<SLActiveTask, SLTask>(
        availableTasks, (a, b) => (a.localizedKey == b.localizedKey));
    return result;
  }

  List<SLTask> _getNotTakenTasks(
      List<SLTask> availableTasks, List<SLActiveTask> activeTasks) {
    List notTakenTasks =
        availableTasks.rest<SLTask, SLActiveTask>(activeTasks, (a, b) {
      return (a.localizedKey == b.localizedKey);
    });
    return notTakenTasks;
  }

  Future<List<SLTask>> _fetchAvailableTasks() async {
    return await sichConnector.readAvailableTasks();
  }

  Future<SLSloboda> _fetchSlobodaStats() async {
    return await sichConnector.readSlobodaStats(widget.city.name);
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
