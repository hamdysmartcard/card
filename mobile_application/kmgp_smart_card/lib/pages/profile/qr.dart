import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/user_data.dart';
import 'package:flutter_smart_card/pages/core/home.dart';
import 'package:flutter_smart_card/widgets/app_button.dart';
import 'package:flutter_smart_card/widgets/app_popup.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../constants.dart';
import '../../models/Profile.dart';
import '../../utils/shared_pref_utils.dart';
import '../../widgets/app_light_text_form_field.dart';
import '../../widgets/app_loading.dart';
import 'package:http/http.dart' as http;

class QrPage extends StatefulWidget {
  QrPage({Key? key}) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  var isLoading = false;

  late Future<int> _loadUserIdFuture;

  @override
  void initState() {
    super.initState();
    _loadUserIdFuture = _loadUserId();
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
          title: Text("Your QR Code",
              style: const TextStyle(
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
              textAlign: TextAlign.center),
        ),
        body: Stack(children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg_home.png"),
                  fit: BoxFit.fill),
            ),
          ),
          FutureBuilder<int>(
              future: _loadUserIdFuture,
              builder: (context, AsyncSnapshot<int> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return AppLoading(isLoading: true);
                  default:
                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));
                    else {
                      return Center(
                        child: QrImage(
                          data:
                              '${Constants.QR_CODE_BASE_URL}/${snapshot.data}',
                          version: QrVersions.auto,
                          size: 320,
                          gapless: false,
                        ),
                      );
                    }
                }
              })
        ]));
  }

  Future<int> _loadUserId() async {
    try {
      setState(() {
        isLoading = true;
      });
      return await SharedPrefUtils.getUserId();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
