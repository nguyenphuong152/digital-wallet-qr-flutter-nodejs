import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymangement/models/user_model.dart';
import 'package:moneymangement/push_notification.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moneymangement/wrapper.dart';

import '../network_handle.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  Future<User> _user;
  //final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final PushNotificationsManager noti = PushNotificationsManager();

  NetworkHandler _networkHandler = NetworkHandler();
  final storage = new FlutterSecureStorage();
  String token;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool validate;
  bool circular = false;

  String email = '';
  String password = '';
  String error = '';
  User user;

  @override
  void initState() {
    super.initState();
    validate = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
            child: Form(
          key: _formKey,
          autovalidate: validate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Chào bạn!',
                style: GoogleFonts.lobster(
                    textStyle: TextStyle(
                  color: Color(0xff5e63b6),
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                )),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: TextFormField(
                  maxLength: 10,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  keyboardType: TextInputType.number,
                  controller: _phoneController,
                  validator: (val) =>
                      val.isEmpty ? 'Nhập số điện thoại' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  decoration: InputDecoration(
                    //errorText: validate ? null : error,
                    border: OutlineInputBorder(),
                    labelText: 'Số điện thoại',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (val) =>
                      val.length < 6 ? 'Mật khẩu phải hơn 6 kí tự' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    //errorText: validate ? null : error,
                    border: OutlineInputBorder(),
                    labelText: 'Mật khẩu',
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              SizedBox(height: 4.0),
              InkWell(
                onTap: () async {
                  setState(() {
                    circular = true;
                  });
                  if (_formKey.currentState.validate()) {
                    // we will send the data to rest server
                    Map<String, dynamic> data = {
                      "username": _phoneController.text,
                      "password": _passwordController.text,
                    };
                    print(data);

                    var response =
                        await _networkHandler.post("/user/login", data);
                    print("login ${response.statusCode}");

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      Map<String, dynamic> output = json.decode(response.body);
                      print(output["token"]);
                      await storage.write(key: "token", value: output["token"]);

                      setState(() {
                        _user = _networkHandler.getUser(_phoneController.text);
                        //print('user setstate ${_user.toString()}');
                        validate = true;
                        circular = false;
                      });
                      await _user;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Wrapper(
                                    userFuture: _user,
                                  )),
                          (route) => false);
                    } else {
                      String output = json.decode(response.body);
                      setState(() {
                        validate = false;
                        error = output;
                        circular = false;
                      });
                    }
                    print(data);
                  } else {
                    setState(() {
                      circular = false;
                      validate = false;
                    });
                  }
                },
                child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff5e63b6),
                    ),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator()
                          : Text(
                              "Đăng nhập",
                              style: GoogleFonts.muli(
                                  textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                    )),
              ),
              FlatButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.fingerprint,
                    color: Color(0xff142850),
                  ),
                  label: Text(
                    'Mở khoá bằng vân tay',
                    style: GoogleFonts.muli(
                        textStyle: TextStyle(
                      color: Color(0xff142850),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    )),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      /*...*/
                    },
                    child: Text(
                      "Quên mật khẩu",
                      style: GoogleFonts.muli(
                          textStyle: TextStyle(
                        color: Color(0xff142850),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: Text(
                      "Đăng kí",
                      style: GoogleFonts.muli(
                          textStyle: TextStyle(
                        color: Color(0xff142850),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      )),
                    ),
                  )
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
