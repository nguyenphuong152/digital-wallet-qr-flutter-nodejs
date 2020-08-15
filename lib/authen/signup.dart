import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymangement/models/user_model.dart';
import 'package:moneymangement/network_handle.dart';
import 'package:moneymangement/screens/home.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //bool isLoading = false;

  //final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  NetworkHandler _networkHandler = NetworkHandler();
  final storage = new FlutterSecureStorage();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  String email = '';
  String password = '';
  String name = '';
  int money = 10000000;
  String phone = '';
  String pin = '0';
  String error = '';
  String id;

  bool validate;
  bool circular = false;

  Future<User> _user;

  @override
  void initState() {
    super.initState();
    validate = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Đăng kí',
              style: GoogleFonts.muli(
                  textStyle: TextStyle(
                color: Color(0xff5e63b6),
                fontSize: 40,
                fontWeight: FontWeight.w700,
              )),
            ),
            SizedBox(
              height: 20.0,
              width: 150.0,
              child: Divider(
                color: Color(0xff5e63b6),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: TextFormField(
                controller: _emailController,
                validator: (val) => val.isEmpty ? 'Nhập email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
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
                  border: OutlineInputBorder(),
                  labelText: 'Mật khẩu',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: TextFormField(
                controller: _usernameController,
                maxLength: 45,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                  labelText: 'Tên của bạn',
                ),
                onChanged: (val) {
                  setState(() => name = val);
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorText: validate ? null : error,
                    border: OutlineInputBorder(),
                    labelText: 'Số điện thoại',
                  ),
                  onChanged: (val) {
                    setState(() => phone = val);
                  },
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                await checkUser();
                if (_formKey.currentState.validate() && validate) {
                  // we will send the data to rest server
                  Map<String, dynamic> data = {
                    "username": _phoneController.text,
                    "email": _emailController.text,
                    "password": _passwordController.text,
                    "name": _usernameController.text,
                    "pin": 111111,
                    "money": 10000000,
                  };
                  print(data);
                  var responseRegister =
                      await _networkHandler.post("/user/register", data);
                  print(responseRegister.statusCode);
                  //Login Logic added here
                  if (responseRegister.statusCode == 200 ||
                      responseRegister.statusCode == 201) {
                    setState(() {
                      _user = _networkHandler.getUser(_phoneController.text);
                    });
                    Map<String, dynamic> data = {
                      "username": _phoneController.text,
                      "password": _passwordController.text,
                    };
                    var response =
                        await _networkHandler.post("/user/login", data);
                    print("status login ${response.statusCode}");

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      print("register and login success");
                      Map<String, dynamic> output = json.decode(response.body);
                      print(output["token"]);
                      await storage.write(key: "token", value: output["token"]);
                      setState(() {
                        validate = true;
                        circular = false;
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              userFuture: _user,
                            ),
                          ),
                          (route) => false);
                    }
                    // } else {
                    //   Scaffold.of(context).showSnackBar(
                    //       SnackBar(content: Text("Network Error")));
                    // }
                  }
                  setState(() {
                    circular = false;
                  });
                } else {
                  setState(() {
                    circular = false;
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
                            "Đăng kí",
                            style: GoogleFonts.muli(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            )),
                          ),
                  )),
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            )
          ],
        ),
      ),
    ));
  }

  checkUser() async {
    if (_phoneController.text.length == 0) {
      setState(() {
        circular = false;
        validate = false;
        error = 'user name cant be empty';
      });
    } else {
      var response = await _networkHandler
          .get("/user/checkusername/${_phoneController.text}");
      if (response["Status"]) {
        setState(() {
          circular = false;
          validate = false;
          error = 'user name already taken';
        });
      } else {
        validate = true;
      }
    }
  }
}
