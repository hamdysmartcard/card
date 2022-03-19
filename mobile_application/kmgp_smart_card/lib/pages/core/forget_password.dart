import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/user_data.dart';
import 'package:flutter_smart_card/widgets/app_popup.dart';
import 'package:flutter_smart_card/widgets/app_square_button.dart';

import '../../constants.dart';
import '../../utils/shared_pref_utils.dart';
import '../../widgets/app_loading.dart';
import '../../widgets/app_dark_text_form_field.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  var _email, _code, _oldPassword, _newPassword;
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: screenHeight * .15,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                      isValidEmail ? "Reset\nPassword" : "Forget\nPassword",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 39.0),
                      textAlign: TextAlign.center),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenPadding),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppDarkTextFormField(
                            isEnabled: !isValidEmail,
                            iconData: Icons.email_outlined,
                            hintText: 'Email',
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            }),
                        if (isValidEmail)
                          AppDarkTextFormField(
                              iconData: Icons.shield,
                              hintText: 'Code',
                              onChanged: (value) {
                                setState(() {
                                  _code = value;
                                });
                              }),
                        if (isValidEmail)
                          AppDarkTextFormField(
                              iconData: Icons.lock_outline,
                              hintText: 'Old Password',
                              isPassword: true,
                              onChanged: (value) {
                                setState(() {
                                  _oldPassword = value;
                                });
                              }),
                        if (isValidEmail)
                          AppDarkTextFormField(
                              iconData: Icons.lock_outline,
                              hintText: 'New Password',
                              isPassword: true,
                              onChanged: (value) {
                                setState(() {
                                  _newPassword = value;
                                });
                              }),
                        if (isValidEmail)
                          AppDarkTextFormField(
                              iconData: Icons.lock_outline,
                              hintText: 'Repeat New Password',
                              isPassword: true,
                              onChanged: (value) {
                                setState(() {
                                  _newPassword = value;
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
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Have an account?",
                      style: const TextStyle(
                          color: const Color(0xff4e4e4e),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left),
                ),
              ),
              AppSquareButton(
                  text: isValidEmail ? 'Reset' : 'Forget',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (isValidEmail)
                        _resetPassword();
                      else
                        _forgetPassword();
                    }
                  })
            ],
          ),
        ),
        AppLoading(isLoading: isLoading)
      ],
    ));
  }

  Future<void> _forgetPassword() async {
    try {
      setState(() {
        isLoading = true;
      });

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${Constants.API_BASE_URL}/forget-password'));
      request.body = json.encode({"email": _email});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);
      final responseMap =
          jsonDecode(responseFromSteam.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        setState(() {
          isValidEmail = true;
        });

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SecondRoute()),
        // );

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

  Future<void> _resetPassword() async {
    try {
      setState(() {
        isLoading = true;
      });

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${Constants.API_BASE_URL}/forget-confermation'));
      request.body = json.encode(
          {"email": _email, "code": _code, "new_password": _newPassword});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);
      final responseMap =
          jsonDecode(responseFromSteam.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        setState(() {
          isValidEmail = true;
        });

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SecondRoute()),
        // );

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
