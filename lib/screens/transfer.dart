import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymangement/models/user_model.dart';
import 'package:moneymangement/network_handle.dart';
import 'package:moneymangement/screens/widget/verifyPin.dart';
import 'package:moneymangement/utilities/currency.dart';

class Transfer extends StatefulWidget {
  // final String uidReceiver;
  final Future<User> userFuture;

  const Transfer({Key key, this.userFuture}) : super(key: key);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  TextEditingController _searchController = TextEditingController();
  Future<User> _user;
  final _formKey = GlobalKey<FormState>();
  NetworkHandler _networkHandler = new NetworkHandler();
  int money;
  int _moneyReceiver;
  int _moneyUser;
  int _userPin;
  String _userId;
  String _idReceiver;
  String _nameReceiver;
  String phone = '';
  String _userPhone;

  // FutureBuilder<User> _userFuture(

  // )

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Chuyển tiền',
                style: GoogleFonts.muli(
                    textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                )),
              ),
              backgroundColor: Color(0xff5e63b6),
            ),
            body: Column(
              children: <Widget>[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'NHẬP SỐ ĐIỆN THOẠI',
                          style: GoogleFonts.muli(
                              textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: TextFormField(
                            controller: _searchController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            style: GoogleFonts.muli(
                                textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Số điện thoại',
                            ),
                            onChanged: (val) {
                              setState(() => phone = val);
                              print('phone ne $phone');
                              if (val.length == 10) {
                                _user = _networkHandler.getUser(val);
                              } else {
                                _user = null;
                              }
                            },
                            validator: (val) {
                              if (val.isEmpty) return 'Hãy nhập số điện thoại';
                              if (val == _userPhone)
                                return 'Số điện thoại không hợp lệ';
                              return null;
                            },
                          ),
                        ),
                        _user == null
                            ? Center()
                            : FutureBuilder<User>(
                                future: _networkHandler.getUser(phone),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    print("snapshot null");
                                    return Text(
                                      'Không tìm thấy người dùng',
                                      style: GoogleFonts.muli(
                                          textStyle: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      )),
                                    );
                                  } else {
                                    _idReceiver = snapshot.data.id;
                                    _nameReceiver = snapshot.data.name;
                                    _moneyReceiver = snapshot.data.money;
                                    return Text(
                                      snapshot.data.name,
                                      style: GoogleFonts.muli(
                                          textStyle: TextStyle(
                                        color: Color(0xff5e63b6),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      )),
                                    );
                                  }
                                })
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'NHẬP SỐ TIỀN',
                          style: GoogleFonts.muli(
                              textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                        ),
                        FutureBuilder<User>(
                          future: widget.userFuture,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            else
                              _moneyUser = snapshot.data.money;
                            _userPin = snapshot.data.pin;
                            _userId = snapshot.data.id;
                            _userPhone = snapshot.data.username;
                            {
                              return TextFormField(
                                style: GoogleFonts.muli(
                                    textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(hintText: 'Số tiền'),
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly,
                                  CurrencyFormat()
                                ],
                                onChanged: (val) {
                                  setState(() => money =
                                      int.parse(val.replaceAll('.', '')));
                                  print('money ne $money');
                                },
                                validator: (val) {
                                  if (val.isEmpty) return 'Hãy nhập số tiền';
                                  if (money < 1000) {
                                    return 'Số tiền phải lớn hơn 1.000';
                                  }
                                  if (money > _moneyUser) {
                                    return 'Số dư trong ví không đủ';
                                  }
                                  return null;
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Color(0xff5e63b6),
                    onPressed: () async {
                      if (_formKey.currentState.validate() &&
                          _user != null) if (_formKey.currentState.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyPin(
                                      userFuture: widget.userFuture,
                                      uidSender: _userId,
                                      uidReceiver: _idReceiver,
                                      userMoney: _moneyUser,
                                      userPIN: _userPin,
                                      money: money,
                                      moneyReceiver: _moneyReceiver,
                                      nameReceiver: _nameReceiver,
                                    )));
                      }
                    },
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 80.0),
                    child: Text(
                      "Xác nhận",
                      style: GoogleFonts.muli(
                          textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                    ),
                  ),
                ),
              ],
            )));
  }
}
