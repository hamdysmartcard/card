import 'package:flutter/material.dart';
import 'package:flutter_smart_card/pages/core/home.dart';
import 'package:flutter_smart_card/pages/core/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  setPathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((instance) {
    var userId = instance.getInt('userId');
    var isLoggedIn = userId != null && userId != -1 && userId != 0;

    runApp(MyApp(isLoggedIn));
  });
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp(this.isLoggedIn);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.black),
      ),
      home: (isLoggedIn ? HomePage() : LoginPage())
      // home: kIsWeb ? WebProfilePage() : (isLoggedIn ? HomePage() : LoginPage()),
      // onGenerateRoute: (settings){
      //     return MaterialPageRoute(
      //       builder: (context) {
      //         return WebProfilePage();
      //     });
      // },
    );
  }
}
