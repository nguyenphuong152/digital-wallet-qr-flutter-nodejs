import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymangement/models/option_model.dart';
import 'package:moneymangement/models/user_model.dart';
import 'package:moneymangement/wrapper.dart';

class Setting extends StatefulWidget {
  final Future<User> userFuture;
  final String uid;

  Setting({this.userFuture, this.uid});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final storage = FlutterSecureStorage();
  //final AuthServices _auth = AuthServices();
  int _selectedOption = 0;
  //NetworkHandler _networkHandler = new NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt',
          style: GoogleFonts.muli(
              textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          )),
        ),
        backgroundColor: Color(0xff5e63b6),
      ),
      body: ListView.builder(
        itemCount: options.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox(height: 15.0);
          } else if (index == options.length + 1) {
            return SizedBox(height: 100.0);
          }
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 80.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: _selectedOption == index - 1
                  ? Border.all(color: Colors.black26)
                  : null,
            ),
            child: ListTile(
              leading: options[index - 1].icon,
              title: Text(
                options[index - 1].title,
                style: GoogleFonts.muli(
                    textStyle: TextStyle(
                  color: _selectedOption == index - 1
                      ? Colors.black
                      : Colors.grey[600],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                )),
              ),
              selected: _selectedOption == index - 1,
              onTap: () async {
                setState(() {
                  _selectedOption = index - 1;
                });
                if (_selectedOption == index - 1) {
                  if (_selectedOption == 5) {
                    await storage.deleteAll();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Wrapper()),
                        (route) => false);
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
