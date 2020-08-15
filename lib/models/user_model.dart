class User {
  final String id;
  final String name;
  final int money;
  final String username;
  final String email;
  final int pin;
  final String pushToken;

  User({
    this.id,
    this.email,
    this.name,
    this.pin,
    this.money,
    this.username,
    this.pushToken,
  });

  // factory User.fromDoc(DocumentSnapshot document) {
  //   return User(
  //     id: document.documentID,
  //     email: document['email'],
  //     name: document['name'],
  //     money: document['money'],
  //     phone: document['phone'],
  //     pin: document['pin'],
  //     pushToken: document['pushToken']
  //   );
  // }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      money: json['money'],
      pin: json['pin'],
      username: json['username'],
      email: json['email'],
    );
    //pin: '0',
    //pushToken: null);
  }
}
