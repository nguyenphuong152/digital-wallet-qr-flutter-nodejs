class TransactionModel {
  final String id;
  final String idSender;
  final String idReceiver;
  final String state;
  final int money;
  final String time;
  final String typeTransaction;
  //final String pushToken;

  TransactionModel(
      {this.id,
      this.idSender,
      this.idReceiver,
      this.state,
      this.money,
      this.time,
      this.typeTransaction});
  // this.pushToken});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
        id: json['_id'],
        idSender: json['idSender'],
        idReceiver: json['idReceiver'],
        state: json['state'],
        money: json['money'],
        time: json['time'],
        typeTransaction: json['typetransaction']);
  }
}
