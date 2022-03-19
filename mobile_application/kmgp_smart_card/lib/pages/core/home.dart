import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/Profile.dart';
import 'package:flutter_smart_card/pages/diseases/diseases.dart';
import 'package:flutter_smart_card/pages/profile/profile.dart';
import 'package:flutter_smart_card/pages/treatments/treatments.dart';
import 'package:flutter_smart_card/widgets/app_popup.dart';

import '../../constants.dart';
import '../../utils/shared_pref_utils.dart';
import '../../widgets/app_loading.dart';
import 'package:http/http.dart' as http;

import '../contacts/contacts.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  late Future<Profile?> _loadUserDataFuture;


  @override
  void initState() {
    super.initState();
    _loadUserDataFuture = _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;

    var buttonsText = ['Profile', 'Diseases', 'Emergency Contacts', 'Treatments'];
    var buttonsOnTap = [() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DiseasesPage()),
      );
    }, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactsPage()),
      );
    }, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TreatmentsPage()),
      );
    }];

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg_home.png"),
                fit: BoxFit.fill),
          ),
        ),
        FutureBuilder<Profile?>(
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
                    return SingleChildScrollView(
                      child: Container(
                        height: screenHeight,
                        width: screenWidth,
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
                            Spacer(),
                            GridView.builder(
                              padding: EdgeInsets.all(20),
                              itemCount: 4,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0),
                              itemBuilder: (BuildContext context, int index) {
                                return MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(30), // <-- Radius
                                  ),
                                  child: Text(buttonsText[index],
                                      style: const TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18.0),
                                      textAlign: TextAlign.center),
                                  color: Colors.black,
                                  onPressed: buttonsOnTap[index],
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  }
              }
            }),
        AppLoading(isLoading: isLoading)
      ],
    ));
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

        if (errorMsg != null) AppPopup.showSimpleMessage(context, message: errorMsg);

        return null;
      }
    } catch (e) {
      AppPopup.showSimpleMessage(context);
      setState(() {
        isLoading = false;
      });
    }finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
