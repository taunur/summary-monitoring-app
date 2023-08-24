import 'dart:convert';
import 'dart:io';

import 'package:summary_monitoring/constan.dart';
import 'package:summary_monitoring/models/rak_model.dart';
import 'package:http/http.dart' as http;

class ServiceMonrak {
  static const _baseRak = baseURL + '/api/monitoring/';

  static Future<List<DataRak>> getMonRak(String token, rak) async {
    final response = await http.get(
      Uri.parse(_baseRak + 'rack?type=$rak'),
      headers: {
        HttpHeaders.contentTypeHeader: 'aplication/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      List data = (jsonObject as Map<String, dynamic>)["list"];
      List<DataRak> dataRak = [];
      dataRak = dataRakModelFromJson(data);
      print(dataRak);
      return dataRak;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load dataRak');
    }
  }

  static Future<List<DataRak>> getAddress(String token, address) async {
    final response = await http.get(
      Uri.parse(_baseRak + 'rack?address=$address'),
      headers: {
        HttpHeaders.contentTypeHeader: 'aplication/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonObject = jsonDecode(response.body);
      List data = (jsonObject as Map<String, dynamic>)["list"];
      List<DataRak> dataAdress = [];
      dataAdress = dataRakModelFromJson(data);
      print(dataAdress);
      return dataAdress;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load dataRak');
    }
  }
}
