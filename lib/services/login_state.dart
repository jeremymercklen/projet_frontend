import 'package:projet_frontend/model/user_account.dart';
import 'package:flutter/cupertino.dart';
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

  get user => _user;

  get token => _token;

  set user(user) {
    _user = user;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("login", _user!.login);
    });
  }

  set token(token) {
    _token = token;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("token", _token!);
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
