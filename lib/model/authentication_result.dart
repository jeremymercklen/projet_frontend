class AuthenticationResult {
  late String login;
  late String token;

  AuthenticationResult(this.login, this.token);

  AuthenticationResult.fromMap(Map<String, dynamic> json) {
    login = json['login'];
    token = json['token'];
  }
}
