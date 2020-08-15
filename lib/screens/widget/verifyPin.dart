import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymangement/models/user_model.dart';
import 'package:moneymangement/network_handle.dart';
import 'package:moneymangement/screens/result_transaction.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPin extends StatefulWidget {
  final Future<User> userFuture;
  final int userMoney;
  final int userPIN;
  final String uidSender;
  final String uidReceiver;
  final int money;
  final int moneyReceiver;
  final String nameReceiver;
  final String userPhone;

  VerifyPin(
      {this.userFuture,
      this.uidSender,
      this.uidReceiver,
      this.userMoney,
      this.userPIN,
      this.money,
      this.moneyReceiver,
      this.nameReceiver,
      this.userPhone});
  @override
  _VerifyPinState createState() => _VerifyPinState();
}

class _VerifyPinState extends State<VerifyPin> {
  TextEditingController _pinHolder = TextEditingController();
  String _pin = '';
  bool _checkPin = false;
  NetworkHandler _networkHandler = new NetworkHandler();

  _submit() async {
    print('vo submit');
    print(widget.uidReceiver);
    print(widget.uidSender);

    Map<String, dynamic> data = {
      "idSender": widget.uidSender,
      "idReceiver": widget.uidReceiver,
      "money": widget.money,
      "state": "success",
      "typetransaction": "chuyen tien"
    };
    print(data);
    var responseTransaction =
        await _networkHandler.post("/transaction/create", data);

    print(responseTransaction.statusCode);
    //create Logic added here
    if (responseTransaction.statusCode == 200 ||
        responseTransaction.statusCode == 201) {
      print("create tran success");
      //update money for 2 users
      Map<String, int> moneySender = {
        "money": widget.userMoney - widget.money,
      };
      Map<String, int> moneyReceiver = {
        "money": widget.moneyReceiver + widget.money,
      };
      var responseUpdateSender = await _networkHandler.patch(
          "/user/update/${widget.uidSender}", moneySender);
      var responseUpdateReceiver = await _networkHandler.patch(
          "/user/update/${widget.uidReceiver}", moneyReceiver);

      if ((responseUpdateSender.statusCode == 200 ||
              responseUpdateSender.statusCode == 201) &&
          (responseUpdateReceiver.statusCode == 200 ||
              responseUpdateReceiver.statusCode == 201)) {
        print("update money user success");
      }
      //Navigator.pop(context);
    }
  }

  _verifyPin() {
    print('verify pin');
    if (_pin == widget.userPIN.toString()) {
      print('vo submit');
      _submit();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ResultTransaction(
                    userFuture: widget.userFuture,
                    moneyTrans: widget.money,
                    moneyUser: widget.userMoney - widget.money,
                    nameReceiver: widget.nameReceiver,
                    idTrans: '3458364913854',
                    userPhone: widget.userPhone,
                  )),
          (Route<dynamic> route) => false);
    } else {
      _checkPin = true;
    }
  }

  String _resultPin() {
    if (_checkPin == true) {
      _pinHolder.clear();
      return 'Bạn nhập sai mã PIN';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Nhập mã PIN',
                  style: GoogleFonts.muli(
                      textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: PinCodeTextField(
                  controller: _pinHolder,
                  onChanged: (input) {
                    print('pin holder $_pinHolder');
                    _pin = input;
                    print(_pin);
                    if (_pin.length == 6) _verifyPin();
                  },
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w100, fontSize: 10),
                  textInputType: TextInputType.number,
                  length: 6,
                  obsecureText: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    selectedColor: Colors.black,
                    inactiveColor: Colors.grey,
                    activeColor: Color(0xff5e63b6),
                    fieldHeight: 50,
                    fieldWidth: 40,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _resultPin(),
                style: TextStyle(color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: FlatButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.fingerprint),
                    label: Text(
                      'Xác thực bằng vân tay',
                      style: GoogleFonts.muli(
                          textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      )),
                    )),
              ),
              FlatButton(
                onPressed: _verifyPin,
                child: Text(
                  'Quên mật khẩu?',
                  style: GoogleFonts.muli(
                      textStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )),
                ),
              )
            ]),
      ),
    );
  }
}
