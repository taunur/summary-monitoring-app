import 'dart:convert';

import 'package:summary_monitoring/models/api_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:summary_monitoring/models/user_model.dart';

import '../constan.dart';

String apiLogin = baseURL + '/api/login';

Future<ApiResponse> login(
    {required String nisp,
    required String password,
    required int roleId}) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(apiLogin),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          "nisp": nisp,
          "password": password,
          "role_id": roleId,
        },
      ),
    );
    switch (response.statusCode) {
      case 200:
        print(response.body);
        apiResponse.data =
            UserModel.fromJson(jsonDecode(response.body)['data']);
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['error'];
        break;
      case 404:
        apiResponse.error = jsonDecode(response.body)['error'];
        break;
      case 400:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWhentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
