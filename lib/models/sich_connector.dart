import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

var productionRoot = 'https://sloboda.locadeserta.com';
var devRoot = productionRoot; // 'http://192.168.1.199:9090';

class SichConnector {
  final String statsUrl = '/sichStats';
  final String tasksUrl = '/tasks';
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

  Future<List> readTasks() async {
    var response = await http.get(root + tasksUrl);
    return jsonDecode(response.body)["tasks"];
  }

  Future<Map> readStats() async {
    print('reading stats');
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
