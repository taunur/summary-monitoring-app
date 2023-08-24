import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:summary_monitoring/constan.dart';
import 'package:summary_monitoring/models/pfgivo_model.dart';

class ServicePfgivo {
  static const _baseUrl = baseURL + '/api/production/inout';

  static Future<List<DataPfgivo>> getData(token) async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        HttpHeaders.contentTypeHeader: 'aplication/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      List data = (jsonObject as Map<String, dynamic>)["list"]["data"];
      List<DataPfgivo> lisData = [];
      lisData = pfgivoModelFromJson(data);
      return lisData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load listData');
    }
  }
}
