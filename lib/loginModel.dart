class Account {
  String id;
  String username;
  String password;


  Account({this.id, this.username, this.password});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
    );
  }
}
