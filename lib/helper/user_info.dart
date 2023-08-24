import 'package:shared_preferences/shared_preferences.dart';

//get token
Future<String> getToken() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('token') ?? '';
}

//get role
Future<String> getrole() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('role') ?? '';
}

//get email
Future<String> getEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('email') ?? '';
}

//get firstName
Future<String> getFirstName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('firstName') ?? '';
}

//get lastName
Future<String> getLastName() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString('lastName') ?? '';
}

//logout
Future<bool> logout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.remove('token');
}
