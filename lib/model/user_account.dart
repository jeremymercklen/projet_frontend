class UserAccount {
  late String login;
  late String? password;

  UserAccount({required this.login, this.password});

  toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['password'] = this.password;
    return data;
  }

  UserAccount.fromMap(Map<String, dynamic> map) {
    login = map['login'];
  }
}
