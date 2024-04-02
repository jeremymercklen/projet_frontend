import 'package:projet_frontend/models/user_account.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState extends ChangeNotifier {
  UserAccount? _user;
  String? _token;

  LoginState() {
    SharedPreferences.getInstance().then((prefs) {
      final token = prefs.getString("token");
      final login = prefs.getString("login");
      if ((token != null) && (login != null)) {
        _user = UserAccount(login: login);
        _token = token;
        notifyListeners();
      }
    });
  }

  bool get connected => _user != null;
  UserAccount get user => _user!;
  String get token => _token!;

  set token(String value) {
    _token = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("token", _token!);
    });
  }

  set user(UserAccount value) {
    _user = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("login", _user!.login);
    });
  }

  disconnect() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove("token");
      prefs.remove("login");
    });
    _user = null;
    _token = null;
    notifyListeners();
  }

}