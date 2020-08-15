import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymangement/models/transaction_model.dart';
import 'package:http/http.dart' as http;
import 'package:moneymangement/screens/widget/trantile.dart';

class HistoryTransaction extends StatefulWidget {
  final String uid;

  HistoryTransaction({this.uid});

  @override
  _HistoryTransactionState createState() => _HistoryTransactionState();
}

class _HistoryTransactionState extends State<HistoryTransaction> {
  List<TransactionModel> _trans = [];

  void initState() {
    super.initState();
    _setupTrans();

    print("uid : ${widget.uid}");
  }

  Future<List<TransactionModel>> fetchTrans(String uid) async {
    var response = await http
        .get("http://e-wallet-qr.herokuapp.com/transaction/user/$uid");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = json.decode(response.body);
      List<TransactionModel> trans = (result['data'] as List)
          .map((data) => TransactionModel.fromJson(data))
          .toList();
      return trans;
    } else {
      throw Exception('Failed to load data');
    }
  }

  _setupTrans() async {
    List<TransactionModel> trans = await fetchTrans(widget.uid);
    setState(() {
      _trans = trans;
    });
  }

  _buildUserTrans() {
    List<TranTile> tranList = [];
    _trans.forEach((tran) {
      print(tran.id);
      tranList.add(
        TranTile(
          uid: widget.uid,
          tranid: tran.id,
        ),
      );
    });
    return Column(children: tranList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Lịch sử giao dịch',
            style: GoogleFonts.muli(
                textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )),
          ),
          backgroundColor: Color(0xff5e63b6),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _setupTrans();
          },
          child: ListView(
            children: <Widget>[
              _buildUserTrans(),
            ],
          ),
        ));
  }
}
