import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneymangement/models/user_model.dart';
import 'griddashboad.dart';
import 'package:google_fonts/google_fonts.dart';
import '../network_handle.dart';

class MainPage extends StatefulWidget {
  final Future<User> userFuture;

  MainPage({this.userFuture});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    super.initState();
  }

  buildProfileInfo(String username, int money) {
    print('user info $username');
    if (username == null) {
      username = "null";
    }
    return Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Xin chào,',
                    style: GoogleFonts.muli(
                        textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    )),
                  ),
                  Text(
                    username,
                    style: GoogleFonts.muli(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    NumberFormat("#,###", "vi").format(money),
                    style: GoogleFonts.muli(
                        textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    )),
                  ),
                  Text(
                    'VND',
                    style: GoogleFonts.muli(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          FutureBuilder<User>(
              future: widget.userFuture,
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print("snapshot data money ${snapshot.data.money}");
                  return Container(
                    child: buildProfileInfo(
                        snapshot.data.name, snapshot.data.money),
                  );
                }
              }),
          SizedBox(
            height: 40,
          ),
          GridDashboard(
            userFuture: widget.userFuture,
          ),
        ],
      ),
    );
  }
}
