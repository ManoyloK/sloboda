import 'dart:convert';

import 'package:http/http.dart' as http;

class SichConnector {
  final String statsUrl = '/sichStats';
  final String root = 'http://192.168.1.141:9090';
  final String send = '/sendSupport';
  final String money = '/money';
  final String cossacks = '/cossacks';

  Future<Map> readStats() async {
    var response = await http.get(root + statsUrl);
    return jsonDecode(response.body);
  }

  Future<bool> sendCossacks(int amount) async {
    var response = await http
        .put(root + send + cossacks + '/${amount.toString()}', body: {});
    return response.statusCode == 200;
  }

  Future<bool> sendMoney(int amount) async {
    var response =
        await http.put(root + send + money + '/${amount.toString()}', body: {});
    return response.statusCode == 200;
  }
}
