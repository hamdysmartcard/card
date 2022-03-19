import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/user_data.dart';
import 'package:flutter_smart_card/pages/core/home.dart';
import 'package:flutter_smart_card/widgets/app_popup.dart';
import 'package:flutter_smart_card/widgets/app_square_button.dart';

import '../../constants.dart';
import '../../utils/shared_pref_utils.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_dark_text_form_field.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  var _name, _email, _username, _password, _passwordRepeat;
  var isLoading = false, isValidEmail = false;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenPadding = screenSize.width * .10;

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: screenHeight * .15,
              ),
              Center(
                child: Text("Welcome back to",
                    style: const TextStyle(
                        color: const Color(0xff4e4e4e),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.left),
              ),
              Center(
                child: Text("Smart Card",
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 39.0),
                    textAlign: TextAlign.left),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenPadding),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppDarkTextFormField(
                            iconData: Icons.person,
                            hintText: 'Name',
                            onChanged: (value) {
                              setState(() {
                                _name = value;
                              });
                            }),
                        AppDarkTextFormField(
                            iconData: Icons.email_outlined,
                            hintText: 'Email',
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            }),
                        AppDarkTextFormField(
                            iconData: Icons.credit_card,
                            hintText: 'Username',
                            onChanged: (value) {
                              setState(() {
                                _username = value;
                              });
                            }),
                        AppDarkTextFormField(
                            iconData: Icons.lock_outline,
                            hintText: 'Password',
                            isPassword: true,
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            }),
                        AppDarkTextFormField(
                            iconData: Icons.lock_outline,
                            hintText: 'Repeat New Password',
                            isPassword: true,
                            onChanged: (value) {
                              setState(() {
                                _passwordRepeat = value;
                              });
                            })
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 15,
                    left: screenPadding,
                    right: screenPadding,
                    bottom: 20),
                child: InkWell(
                  child: Text("Have an account?",
                      style: const TextStyle(
                          color: const Color(0xff4e4e4e),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  ),
                ),
              ),
              AppSquareButton(
                  text: 'Register',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _register();
                    }
                  })
            ],
          ),
        ),
        AppLoading(isLoading: isLoading)
      ],
    ));
  }

  Future<void> _register() async {
    try {
      setState(() {
        isLoading = true;
      });

      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('${Constants.API_BASE_URL}/register'));
      request.body = json.encode({
        "email": _email,
        "username": _username,
        "password": _password,
        "name": _name
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);
      final responseMap =
          jsonDecode(responseFromSteam.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        var userData = UserData.fromJson(responseMap);
        await SharedPrefUtils.saveUserData(userData.id, _name, null);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        String? errorMsg = (responseMap['error'] as List<dynamic>).first;

        if (errorMsg != null)
          AppPopup.showSimpleMessage(context, message: errorMsg);
      }
    } catch (e) {
      AppPopup.showSimpleMessage(context);
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
