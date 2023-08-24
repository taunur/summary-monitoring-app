import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:summary_monitoring/constan.dart';
import 'package:summary_monitoring/models/api_response_model.dart';
import 'package:summary_monitoring/models/user_model.dart';
import 'package:summary_monitoring/services/auth_service.dart';
import 'package:summary_monitoring/theme.dart';
import 'package:summary_monitoring/widgets/button_default.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController textNis = TextEditingController();
  TextEditingController textPassword = TextEditingController();

  bool _secureText = true;
  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
          Container(
              margin: const EdgeInsets.only(left: 5),
              child: const Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  var valueRoles;
  List roleList = [];

  Future getRoles() async {
    final response = await http.get(
      Uri.parse(baseURL + '/api/roles'),
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        // 'Authorization': 'Bearer $token'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      setState(() {
        roleList = jsonData;
      });
    }
  }

  void functionLoginUser() async {
    showAlertDialog(context);
    ApiResponse response = await login(
        nisp: textNis.text,
        password: textPassword.text,
        roleId: int.parse(valueRoles));

    if (response.error == null) {
      saveAndRedirectToHome(response.data as UserModel);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void saveAndRedirectToHome(UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', userModel.token);
    // await preferences.setString('role', roles.toString());
    // await preferences.setString('email', userModel.email);
    // await preferences.setString('firstName', userModel.firstName);
    // await preferences.setString('lastName', userModel.lastName);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  check() {
    final form = _key.currentState!;
    if (form.validate()) {
      form.save();
      functionLoginUser();
    }
  }

  @override
  void initState() {
    super.initState();
    getRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgrounColor1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 24),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'DCS Production',
                      style: textOpenSans.copyWith(
                        color: blackColor,
                        fontSize: 24,
                        fontWeight: extraBold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Warehouse & Delivery',
                      style: textOpenSans.copyWith(
                        color: blackColor.withOpacity(0.6),
                        fontSize: 16,
                        fontWeight: semiBold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Center(
                      child: SizedBox(
                        height: 150,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: const Offset(
                                3, 0), // changes position of shadow
                          ),
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(24),
                        ),
                        color: whiteColor),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NISP',
                            style: textOpenSans.copyWith(
                              color: black2Color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: primaryColor, width: 1.0),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                controller: textNis,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Your NISP',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Password',
                            style: textOpenSans.copyWith(
                              color: black2Color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: primaryColor, width: 1.0),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                controller: textPassword,
                                obscureText: _secureText,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Your Password',
                                  suffixIcon: IconButton(
                                    onPressed: showHide,
                                    icon: Icon(_secureText
                                        ? Icons.visibility_outlined
                                        : Icons.visibility),
                                    color: const Color(0xff4B556B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Select Role',
                            style: textOpenSans.copyWith(
                              color: black2Color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: primaryColor, width: 1.0),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  icon: const ImageIcon(
                                    AssetImage('assets/icons/arrow-down.png'),
                                  ),
                                  dropdownColor: const Color(0xffF0F1F2),
                                  borderRadius: BorderRadius.circular(15),
                                  hint: const Text('Select Role'),
                                  items: roleList.map((item) {
                                    return DropdownMenuItem(
                                      value: item['id'].toString(),
                                      child: Text(item['name'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      valueRoles = newVal;
                                      print(valueRoles);
                                    });
                                  },
                                  value: valueRoles,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ButtonCustom(
                            title: 'Login',
                            press: () {
                              if (valueRoles == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Role Is Required')));
                              } else {
                                check();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
