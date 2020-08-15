import 'package:flutter/material.dart';

import 'package:moneymangement/push_notification.dart';

import 'package:moneymangement/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Widget page = SplashScreen();
  PushNotificationsManager _noti = new PushNotificationsManager();
  //final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    //checkLogin();
  }

  // void checkLogin() async {
  //   String token = await storage.read(key: "token");
  //   if (token == null) {
  //     setState(() {
  //       page = SignIn();
  //     });
  //     // } else {
  //     //   setState(() {
  //     //     page = Home();
  //     //   });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _noti.init();
    return MaterialApp(
      home: Wrapper(),
    );
  }
}
