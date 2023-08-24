import 'dart:convert';
import 'dart:io';

import 'package:summary_monitoring/constan.dart';
import 'package:summary_monitoring/models/mivo_model.dart';
import 'package:http/http.dart' as http;

class ServiceMivo {
  static const _baseInOut = baseURL + '/api/mStocks/inout';

  static Future<List<DataMivo>> getDataMivo(String token, id) async {
    final response = await http.get(
      Uri.parse(_baseInOut + '?material_id=$id'),
      headers: {
        HttpHeaders.contentTypeHeader: 'aplication/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      print(jsonObject);
      List data = (jsonObject as Map<String, dynamic>)["list"];
      List<DataMivo> dataMivo = [];
      dataMivo = mivoModelFromJson(data);
      return dataMivo;
    } else if (response.statusCode == 401) {
      throw Exception('Show dialog $unauthorized');
    } else if (response.statusCode == 404) {
      throw Exception('Show dialog 404 Not Found');
    } else if (response.statusCode == 503) {
      throw Exception('Show dialog for error 503');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Show dialog for other errors');
    }
  }
}
