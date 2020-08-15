import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moneymangement/models/transaction_model.dart';
import 'package:moneymangement/models/user_model.dart';
import 'package:moneymangement/network_handle.dart';

class TranTile extends StatefulWidget {
  final String uid;
  final String tranid;

  const TranTile({Key key, this.uid, this.tranid}) : super(key: key);
  @override
  _TranTileState createState() => _TranTileState();
}

class _TranTileState extends State<TranTile> {
  NetworkHandler _networkHandler = new NetworkHandler();
  String _idReceiver;
  String _tranState;
  String _idSender;
  String _time;
  int _money;
  String _nameReceiver;
  String _nameSender;
  bool isloading = false;
//  User _receiver;

  //NetworkHandler

  @override
  void initState() {
    super.initState();
    _getTran();
  }

  String checkStateTitle(String state, String userId, String idReceiver) {
    if (state == 'success' && (userId != idReceiver))
      return 'Chuyển tiền thành công';
    else if (state == 'success' && (userId == idReceiver))
      return 'Bạn đã nhận được tiền';
    return null;
  }

  String checkStateText(String userId, String idReceiver) {
    if (userId != idReceiver)
      return 'Bạn đã chuyển ${NumberFormat("#,###", "vi").format(_money)}đ cho $_nameReceiver';
    else if (userId == idReceiver)
      return 'Bạn đã nhận ${NumberFormat("#,###", "vi").format(_money)}đ từ $_nameSender';
  }

  String checkStateImage(String userId, String idReceiver) {
    if (userId != idReceiver)
      return 'images/givemoney.png';
    else if (userId == idReceiver) return 'images/takemoney.png';
  }

  _getTran() async {
    setState(() {
      isloading = true;
    });
    TransactionModel tran = await _networkHandler.getTranwithId(widget.tranid);
    if (tran != null) {
      print(tran.state);
      User sender = await _networkHandler.getUserwithId(tran.idSender);
      User receiver = await _networkHandler.getUserwithId(tran.idReceiver);

      setState(() {
        _idReceiver = tran.idReceiver;
        _tranState = tran.state;
        _idSender = tran.idSender;
        _time = tran.time;
        _money = tran.money;
        _nameSender = sender.name;
        _nameReceiver = receiver.name;
        isloading = false;
      });
    }
    //User receiver = await _networkHandler.getUserwithId(_idReceiver);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: isloading
            ? SizedBox.shrink()
            : ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      AssetImage(checkStateImage(widget.uid, _idReceiver)),
                ),
                title: Text(
                  checkStateTitle(_tranState, widget.uid, _idReceiver),
                  style: GoogleFonts.muli(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      checkStateText(widget.uid, _idReceiver),
                      style: GoogleFonts.muli(
                          textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      _time,
                      style: GoogleFonts.muli(
                          textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      )),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
      ),
      decoration: new BoxDecoration(
          border: new Border(bottom: new BorderSide(color: Colors.grey[300]))),
    );
  }
}
