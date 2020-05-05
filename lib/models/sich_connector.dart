import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sloboda/models/sich/backend_models.dart';

var productionRoot = 'https://sloboda.locadeserta.com';
var devRoot = productionRoot; // 'http://192.168.1.199:9090';

class SichConnector {
  final String statsUrl = '/sichStats';
  final String tasksUrl = '/tasks';
  final String slobodaStatsUrl = '/slobodaStats';
  final String registerTask = '/registerTask';
  final String doTaskUrl = '/doTask';

  String get root {
    if (kDebugMode) {
      return devRoot;
    } else {
      return productionRoot;
    }
  }

  final String send = '/sendSupport';
  final String money = '/money';
  final String cossacks = '/cossacks';

  Future<List> readAvailableTasks() async {
    var response = await http.get(root + tasksUrl);
    List tasks = jsonDecode(response.body)["tasks"];

    return tasks.map((taskMap) => SLTask.fromJson(taskMap)).toList();
  }

  Future<SLSloboda> doTask(
      String slobodaName, String taskName, int amount) async {
    var response = await http.put(root +
        doTaskUrl +
        '/' +
        slobodaName +
        '/' +
        taskName +
        '/' +
        amount.toString());
    if (response.statusCode == 200) {
      Map responseMap = jsonDecode(response.body);
      return SLSloboda.fromJson(responseMap);
    } else {
      return null;
    }
  }

  Future<SLSloboda> readSlobodaStats(String slobodaName) async {
    var response = await http.get(root + slobodaStatsUrl + '/${slobodaName}');
    if (response.statusCode == 200) {
      Map responseMap = jsonDecode(response.body);
      SLSloboda sloboda = SLSloboda.fromJson(responseMap);
      return sloboda;
    } else {
      return null;
    }
  }

  Future registerTaskForSloboda(String slobodaName, String taskName) async {
    var result =
        await http.put(root + registerTask + '/${slobodaName}/${taskName}');

    return result;
  }

  Future<Map> readStats() async {
    var response = await http.get(root + statsUrl);
    return jsonDecode(response.body);
  }

  Future<bool> sendCossacks(int amount, String slobodaName) async {
    var url =
        root + send + '/$slobodaName' + cossacks + '/${amount.toString()}';
    var response = await http.put(Uri.encodeFull(url), body: {});
    return response.statusCode == 200;
  }

  Future<bool> sendMoney(int amount, String slobodaName) async {
    var url = root + send + '/$slobodaName' + money + '/${amount.toString()}';
    var response = await http.put(Uri.encodeFull(url), body: {});
    return response.statusCode == 200;
  }
}
