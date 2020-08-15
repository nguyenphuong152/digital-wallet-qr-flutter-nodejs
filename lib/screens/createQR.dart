import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneymangement/models/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateQR extends StatefulWidget {
  final Future<User> userFuture;

  const CreateQR({Key key, this.userFuture}) : super(key: key);
  @override
  _CreateQRState createState() => _CreateQRState();
}

class _CreateQRState extends State<CreateQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mã QR',
          style: GoogleFonts.muli(
              textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          )),
        ),
        backgroundColor: Color(0xff5e63b6),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Đưa mã này cho khách hàng thanh toán',
              style: GoogleFonts.muli(
                  textStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
            ),
            SizedBox(height: 20.0),
            FutureBuilder<User>(
              future: widget.userFuture,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff5e63b6), width: 1.5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: QrImage(
                      data: snapshot.data.id,
                      version: QrVersions.auto,
                      size: 250.0,
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            FlatButton.icon(
              onPressed: null,
              icon: Icon(
                Icons.share,
                color: Colors.grey,
              ),
              label: Text(
                'Chia sẻ mã QR',
                style: GoogleFonts.muli(
                    textStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
