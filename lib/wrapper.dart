import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moneymangement/authen/authen.dart';
import 'package:moneymangement/screens/home.dart';
import 'models/user_model.dart';

class Wrapper extends StatefulWidget {
  final Future<User> userFuture;

  const Wrapper({
    Key key,
    this.userFuture,
  }) : super(key: key);
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final storage = new FlutterSecureStorage();
  bool checkToken = true;
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String token = await storage.read(key: "token");
    if (token == null) {
      setState(() {
        checkToken = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("vo wrapper");
    if (widget.userFuture == null || checkToken == false)
      return Authentication();
    else
      return FutureBuilder<User>(
          future: widget.userFuture,
          builder: (ctx, snapshot) {
            print("wrapper id user ${snapshot.data.id}");
            print("wrapper money user ${snapshot.data.money}");
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Home(userFuture: widget.userFuture, uid: snapshot.data.id);
            }
          });
  }
}
