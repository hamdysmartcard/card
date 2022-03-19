import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/Profile.dart';
import 'package:flutter_smart_card/models/treatment.dart';
import 'package:flutter_smart_card/widgets/app_popup.dart';

import '../../constants.dart';
import '../../models/disease.dart';
import '../../utils/shared_pref_utils.dart';
import '../../widgets/app_loading.dart';
import 'package:http/http.dart' as http;

import 'treatment_popup.dart';

class TreatmentsPage extends StatefulWidget {
  TreatmentsPage({Key? key}) : super(key: key);

  @override
  _TreatmentsPageState createState() => _TreatmentsPageState();
}

class _TreatmentsPageState extends State<TreatmentsPage> {
  var isLoading = false;

  late Future<Profile?> _loadUserDataFuture;
  late Future<List<Treatment>?> _loadTreatmentsFuture;


  @override
  void initState() {
    super.initState();
    _loadUserDataFuture = _loadUserData();
    _loadTreatmentsFuture = _loadTreatments();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;

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

                    return FutureBuilder<List<Treatment>?>(
                        future: _loadTreatmentsFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Treatment>?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return AppLoading(isLoading: true);
                            default:
                              if (snapshot.hasError)
                                return Center(
                                    child: Center(
                                        child:
                                            Text('Error: ${snapshot.error}')));
                              else {
                                List<Treatment>? treatments = snapshot.data;

                                return SingleChildScrollView(
                                  child: Container(
                                    height: screenHeight,
                                    width: screenWidth,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: screenHeight * .10,
                                        ),
                                        Image.asset(
                                            'assets/images/profile_picture.png',
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
                                          height: 15,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          width: double.infinity,
                                          child: Wrap(
                                            alignment: WrapAlignment.end,
                                            children: [
                                              ElevatedButton.icon(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ))),
                                                onPressed: () async {
                                                  var contactToAdd =
                                                      await AddOrUpdateTreatmentPopup
                                                          .showPopup(
                                                              context,
                                                          treatment: null);

                                                  if (contactToAdd != null)
                                                  _addDisease(contactToAdd);
                                                },
                                                icon: Icon(Icons.add),
                                                label: Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (treatments?.isEmpty == true)
                                          Container(
                                            child: Center(
                                              child: Text('Empty Diseases'),
                                            ),
                                          ),
                                        if (treatments?.isEmpty == false)
                                          ListView.builder(
                                            padding: EdgeInsets.all(20),
                                            itemCount: treatments?.length ?? 0,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () async {
                                                  var contactToUpdate =
                                                      await AddOrUpdateTreatmentPopup
                                                          .showPopup(
                                                              context,
                                                          treatment: treatments![index]);

                                                  if (contactToUpdate != null)
                                                  _updateContact(contactToUpdate);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    color: Color(0xffe1f6f4),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Text(
                                                      '${treatments![index]
                                                          .treatment ?? ''} - ${treatments[index]
                                                          .dose ?? ''}',
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff656565),
                                                          fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                          fontFamily:
                                                              "Poppins",
                                                          fontStyle:
                                                              FontStyle
                                                                  .normal,
                                                          fontSize: 12.8),
                                                      textAlign:
                                                          TextAlign.left),
                                                ),
                                              );
                                            },
                                          )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          }
                        });
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

  Future<List<Treatment>?> _loadTreatments() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userId = await SharedPrefUtils.getUserId();

      var request = http.Request('GET',
          Uri.parse('${Constants.API_BASE_URL}/treatment/$userId'));

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);

      if (response.statusCode == 200) {
        final responseMapList =
            jsonDecode(responseFromSteam.body) as List<dynamic>;

        var diseases =
            responseMapList.map((e) => Treatment.fromJson(e)).toList();

        return diseases;
      } else {
        final responseMap =
            jsonDecode(responseFromSteam.body) as Map<String, dynamic>;

        String? errorMsg = (responseMap['error'] as List<dynamic>).first;
        String? detailsMsg = (responseMap['detail'] as List<dynamic>).first;

        if (errorMsg != null || detailsMsg != null)
          AppPopup.showSimpleMessage(context, message: errorMsg ?? detailsMsg ?? '');

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

  Future<void> _addDisease(Treatment treatment) async {
    try {
      setState(() {
        isLoading = true;
      });
      var userId = await SharedPrefUtils.getUserId();

      var headers = {'Content-Type': 'application/json'};

      var request = http.Request(
          'POST', Uri.parse('${Constants.API_BASE_URL}/treatment'));
      request.body = json.encode({
        "user": userId,
        "treatment": treatment.treatment,
        "dose": treatment.dose,
        "is_healed": treatment.isHealed
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);

      if (response.statusCode == 201) {
        setState(() {
          _loadTreatmentsFuture = _loadTreatments();
        });
      } else {
        final responseMap =
            jsonDecode(responseFromSteam.body) as Map<String, dynamic>;

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

  Future<void> _updateContact(Treatment treatment) async {
    try {
      setState(() {
        isLoading = true;
      });
      var userId = await SharedPrefUtils.getUserId();

      var headers = {'Content-Type': 'application/json'};

      var request = http.Request(
          'PUT', Uri.parse('${Constants.API_BASE_URL}/treatment'));
      request.body = json.encode({
        "user": userId,
        "id": treatment.id,
        "treatment": treatment.treatment,
        "dose": treatment.dose,
        "is_healed": treatment.isHealed
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);

      if (response.statusCode == 200) {
        setState(() {
          _loadTreatmentsFuture = _loadTreatments();
        });
      } else {
        final responseMap =
            jsonDecode(responseFromSteam.body) as Map<String, dynamic>;

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
