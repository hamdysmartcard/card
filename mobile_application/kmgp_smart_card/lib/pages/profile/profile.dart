import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/user_data.dart';
import 'package:flutter_smart_card/pages/core/home.dart';
import 'package:flutter_smart_card/pages/profile/qr.dart';
import 'package:flutter_smart_card/widgets/app_button.dart';
import 'package:flutter_smart_card/widgets/app_popup.dart';

import '../../constants.dart';
import '../../models/Profile.dart';
import '../../utils/shared_pref_utils.dart';
import '../../widgets/app_light_text_form_field.dart';
import '../../widgets/app_loading.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  var _name,
      _phoneNumber,
      _address,
      _bloodType,
      _nationalId,
      _fbUrl,
      _instaUrl,
      _waNumber;
  var isLoading = false;
  bool? _isAddictive;

  late Future<Profile?> _loadUserDataFuture;

  @override
  void initState() {
    super.initState();
    _loadUserDataFuture = _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    var screenPadding = screenSize.width * .10;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Profile",
              style: const TextStyle(
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
              textAlign: TextAlign.center),
        ),
        body: FutureBuilder<Profile?>(
            future: _loadUserDataFuture,
            builder: (BuildContext context, AsyncSnapshot<Profile?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return AppLoading(isLoading: true);
                default:
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  else {
                    Profile? profile = snapshot.data;
                    if (_isAddictive == null)
                      _isAddictive = profile?.isAddictive ?? false;

                    return Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/bg_home.png"),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: screenHeight * .10,
                              ),
                              Image.asset('assets/images/profile_picture.png',
                                  width: screenWidth * .40),
                              Text(profile?.name ?? '',
                                  style: const TextStyle(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 25.0),
                                  textAlign: TextAlign.left),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenPadding),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppLightTextFormField(
                                            initialValue: profile?.name ?? '',
                                            hintText: 'Name',
                                            onChanged: (value) {
                                              setState(() {
                                                _name = value;
                                              });
                                            }),
                                        AppLightTextFormField(
                                            initialValue:
                                                profile?.phoneNumber ?? '',
                                            hintText: 'Phone Number',
                                            onChanged: (value) {
                                              setState(() {
                                                _phoneNumber = value;
                                              });
                                            }),
                                        AppLightTextFormField(
                                            initialValue:
                                                profile?.address ?? '',
                                            hintText: 'Address',
                                            onChanged: (value) {
                                              setState(() {
                                                _address = value;
                                              });
                                            }),
                                        AppLightTextFormField(
                                            initialValue:
                                                profile?.bloodType ?? '',
                                            hintText: 'Blood Type',
                                            onChanged: (value) {
                                              setState(() {
                                                _bloodType = value;
                                              });
                                            }),
                                        AppLightTextFormField(
                                            keyboardType: TextInputType.number,
                                            initialValue: profile?.nationalId
                                                    ?.toString() ??
                                                '',
                                            hintText: 'National Id',
                                            onChanged: (value) {
                                              setState(() {
                                                _nationalId = value;
                                              });
                                            }),
                                        AppLightTextFormField(
                                            initialValue:
                                                profile?.facebook ?? '',
                                            hintText: 'Facebook Url',
                                            onChanged: (value) {
                                              setState(() {
                                                _fbUrl = value;
                                              });
                                            }),
                                        AppLightTextFormField(
                                            initialValue:
                                                profile?.instagram ?? '',
                                            hintText: 'Instagram Url',
                                            onChanged: (value) {
                                              setState(() {
                                                _instaUrl = value;
                                              });
                                            }),
                                        AppLightTextFormField(
                                            initialValue:
                                                profile?.whatsapp ?? '',
                                            hintText: 'Whatsapp Number',
                                            onChanged: (value) {
                                              setState(() {
                                                _waNumber = value;
                                              });
                                            }),
                                        CheckboxListTile(
                                          title: Text("Is Addictive"),
                                          value: _isAddictive,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _isAddictive = newValue ?? false;
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          checkColor: Colors.white,
                                          activeColor: Colors.black,
                                        )
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: AppButton(
                                    text: 'Update',
                                    isOutline: true,
                                    onTap: () => _updateUserData()),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: AppButton(
                                    text: 'Share Qr-Code',
                                    onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => QrPage()),
                                        )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        AppLoading(isLoading: isLoading)
                      ],
                    );
                  }
              }
            }));
  }

  Future<void> _updateUserData() async {
    try {
      setState(() {
        isLoading = true;
      });

      var userId = await SharedPrefUtils.getUserId();

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'PUT', Uri.parse('${Constants.API_BASE_URL}/profile/$userId'));
      request.body = json.encode({
        "name": _name,
        "phone_number": _phoneNumber,
        // "profile_image": null,
        "address": _address,
        "blood_type": _bloodType,
        "is_addictive": _isAddictive,
        if (_nationalId != null)
        "national_id": int.tryParse(_nationalId),
        "whatsapp": _waNumber,
        "facebook": _fbUrl,
        "instagram": _instaUrl
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
        String? errorMsg = (responseMap['error'] as List<dynamic>?)?.first;

        if (errorMsg != null)
          AppPopup.showSimpleMessage(context, message: errorMsg);
      }
    } catch (e) {
      AppPopup.showSimpleMessage(context, message: e.toString());
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Profile?> _loadUserData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userId = await SharedPrefUtils.getUserId();

      var request = http.Request(
          'GET', Uri.parse('${Constants.API_BASE_URL}/profile/$userId'));

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);
      final responseMap =
          jsonDecode(responseFromSteam.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        var profile = Profile.fromJson(responseMap);
        await SharedPrefUtils.saveUserData(
            userId, profile.name, profile.profileImage);

        return profile;
      } else {
        String? errorMsg = (responseMap['error'] as List<dynamic>).first;

        if (errorMsg != null)
          AppPopup.showSimpleMessage(context, message: errorMsg);

        return null;
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
