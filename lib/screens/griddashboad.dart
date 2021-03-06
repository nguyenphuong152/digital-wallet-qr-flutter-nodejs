import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneymangement/models/user_model.dart';
import 'package:moneymangement/screens/createQR.dart';
import 'package:moneymangement/screens/transaction.dart';
import 'package:moneymangement/screens/transfer.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class GridDashboard extends StatefulWidget {
  final Future<User> userFuture;

  GridDashboard({Key key, this.userFuture}) : super(key: key);

  @override
  _GridDashboardState createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  Item item1 = new Item(
    title: 'Mã QR',
    img: 'images/qrcode.png',
  );

  Item item2 = new Item(
    title: 'Quét QR',
    img: 'images/qrscan.png',
  );

  Item item3 = new Item(
    title: 'Nạp tiền',
    img: 'images/coin.png',
  );

  Item item4 = new Item(
    title: 'Rút tiền',
    img: 'images/losemoney.png',
  );

  Item item5 = new Item(
    title: 'Chuyển tiền',
    img: 'images/exchangemoney.png',
  );

  Item item6 = new Item(
    title: 'Thẻ',
    img: 'images/wallet.png',
  );

  @override
  Widget build(BuildContext context) {
    List<Item> myItem = [item1, item2, item3, item4, item5, item6];
    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: myItem.map((data) {
          return GestureDetector(
            onTap: () async {
              if (data.title == 'Mã QR')
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateQR(
                              userFuture: widget.userFuture,
                            )));
              else if (data.title == 'Quét QR') {
                String result_Qr = await scanner.scan();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Transaction(
                              uidReceiver: result_Qr,
                              userFuture: widget.userFuture,
                            )));
              } else if (data.title == 'Chuyển tiền')
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Transfer(
                              userFuture: widget.userFuture,
                            )));
              // else if (data.title == 'Thẻ')
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => CardManagement(
              //                 user: widget.user,
              //               )));
              // else if (data.title == 'Nạp tiền')
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => CashIn(
              //                 user: widget.user,
              //               )));
              // else if (data.title == 'Rút tiền')
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => CashOut(
              //                 user: widget.user,
              //               )));
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff5e63b6), width: 2.0),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 70,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.muli(
                          textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                    )
                  ],
                )),
          );
        }).toList(),
      ),
    );
  }
}

class Item {
  String title;
  String img;

  Item({this.title, this.img});
}
