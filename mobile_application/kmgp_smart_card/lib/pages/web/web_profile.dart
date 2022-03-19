import 'package:flutter/material.dart';
import 'package:flutter_smart_card/pages/profile/qr.dart';
import 'package:flutter_smart_card/widgets/app_button.dart';
import 'package:flutter_smart_card/widgets/app_popup.dart';

import '../../models/Profile.dart';
import '../../widgets/app_light_text_form_field.dart';
import '../../widgets/app_loading.dart';
import 'package:http/http.dart' as http;

class WebProfilePage extends StatefulWidget {
  WebProfilePage({Key? key}) : super(key: key);

  @override
  _WebProfilePageState createState() => _WebProfilePageState();
}

class _WebProfilePageState extends State<WebProfilePage> {
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
                                  width: screenWidth * .30),
                              Text(profile?.name ?? '',
                                  style: const TextStyle(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 25.0),
                                  textAlign: TextAlign.left),
                              if (profile?.nationalId != null)
                                Text("National Id: ${profile?.nationalId}",
                                    style: const TextStyle(
                                        color: const Color(0xff4e4e4e),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
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
                                                    .toString() ??
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
                                    onTap: () {}),
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

  Future<Profile?> _loadUserData() async {
    print('_loadUserData');
    try {
      setState(() {
        isLoading = true;
      });

      var request =
          http.Request('GET', Uri.parse('http://3.124.145.224/api/web/1'));
      http.StreamedResponse response = await request.send();

      print('${response.statusCode}');
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }

    } catch (e) {
      print('catch: ${e}');
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
