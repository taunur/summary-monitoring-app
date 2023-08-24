import 'dart:convert';

import '../constan.dart';
import '../helper/user_info.dart';
import '../models/api_response_model.dart';
import 'package:http/http.dart' as http;

import '../models/msm_model.dart';

Future<ApiResponse> getTabelMontoringMaterial() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response =
        await http.get(Uri.parse(baseURL + '/api/mstocks/minmax'), headers: {
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        // print(response.body);
        apiResponse.data = jsonDecode(response.body)['list']['data']
            .map((p) => MsmModel.fromJson(p))
            .toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        String? somethingWentWrong;
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
