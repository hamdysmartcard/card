import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/Profile.dart';
import 'package:flutter_smart_card/models/emergency_contact.dart';
import 'package:flutter_smart_card/widgets/app_popup.dart';

import '../../constants.dart';
import '../../utils/shared_pref_utils.dart';
import '../../widgets/app_loading.dart';
import 'package:http/http.dart' as http;

import 'contact_popup.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  var isLoading = false;

  late Future<Profile?> _loadUserDataFuture;
  late Future<List<EmergencyContact>?> _loadContactsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserDataFuture = _loadUserData();
    _loadContactsFuture = _loadContacts();
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

                    return FutureBuilder<List<EmergencyContact>?>(
                        future: _loadContactsFuture,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<EmergencyContact>?> snapshot) {
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
                                List<EmergencyContact>? contacts =
                                    snapshot.data;

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
                                                      await AddOrUpdateContactPopup
                                                          .showPopup(
                                                              context,
                                                              contact: null);

                                                  if (contactToAdd != null)
                                                  _addContact(contactToAdd);
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
                                        if (contacts?.isEmpty == true)
                                          Container(
                                            child: Center(
                                              child: Text('Empty Contacts'),
                                            ),
                                          ),
                                        if (contacts?.isEmpty == false)
                                          ListView.builder(
                                            padding: EdgeInsets.all(20),
                                            itemCount: contacts?.length ?? 0,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () async {
                                                  var contactToUpdate =
                                                      await AddOrUpdateContactPopup
                                                          .showPopup(
                                                              context,
                                                              contact: contacts![index]);

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
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        child: Text(
                                                            contacts![index]
                                                                    .name ??
                                                                '',
                                                            style: const TextStyle(
                                                                color: const Color(
                                                                    0xff656565),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize: 12.8),
                                                            textAlign:
                                                                TextAlign.left),
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        child: Text(
                                                            contacts[index]
                                                                    .phoneNumber ??
                                                                '',
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
                                                      )
                                                    ],
                                                  ),
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

  Future<List<EmergencyContact>?> _loadContacts() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userId = await SharedPrefUtils.getUserId();

      var request = http.Request('GET',
          Uri.parse('${Constants.API_BASE_URL}/emergency-contacts/$userId'));

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);

      if (response.statusCode == 200) {
        final responseMapList =
            jsonDecode(responseFromSteam.body) as List<dynamic>;

        var contacts =
            responseMapList.map((e) => EmergencyContact.fromJson(e)).toList();

        return contacts;
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

  Future<void> _addContact(EmergencyContact contact) async {
    try {
      setState(() {
        isLoading = true;
      });
      var userId = await SharedPrefUtils.getUserId();

      var headers = {'Content-Type': 'application/json'};

      var request = http.Request(
          'POST', Uri.parse('${Constants.API_BASE_URL}/emergency-contacts'));
      request.body = json.encode({
        "user": userId,
        "index": contact.index,
        "name": contact.name,
        "phone_number": contact.phoneNumber
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);

      if (response.statusCode == 201) {
        setState(() {
          _loadContactsFuture = _loadContacts();
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

  Future<void> _updateContact(EmergencyContact contact) async {
    try {
      setState(() {
        isLoading = true;
      });
      var userId = await SharedPrefUtils.getUserId();

      var headers = {'Content-Type': 'application/json'};

      var request = http.Request(
          'PUT', Uri.parse('${Constants.API_BASE_URL}/emergency-contacts'));
      request.body = json.encode({
        "user": userId,
        "id": contact.id,
        "index": contact.index,
        "name": contact.name,
        "phone_number": contact.phoneNumber
      });
      print('ss:${request.body}');
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var responseFromSteam = await http.Response.fromStream(response);
      print(responseFromSteam.body);

      if (response.statusCode == 200) {
        setState(() {
          _loadContactsFuture = _loadContacts();
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
