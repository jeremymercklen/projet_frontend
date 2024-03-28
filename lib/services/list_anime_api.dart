import 'dart:convert';

import 'package:projet_frontend/models/user_account.dart';
import 'package:projet_frontend/models/authentication_result.dart';
import 'package:projet_frontend/models/list_animes.dart';
import 'package:projet_frontend/services/login_state.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class StatusErrorException {
  final int _statusCode;

  const StatusErrorException(this._statusCode);

  get statusCode => _statusCode;
}

class AnimeListAPI {
  static const apiServer = '192.168.2.101:3333';
  static const apiUrl = '';
}

class UserAccountRoutes extends AnimeListAPI {
  static const userAccountRoutes = '${AnimeListAPI.apiUrl}/useraccount';
  static const authRoutes = '$userAccountRoutes/authenticate';

  Future insert(UserAccount userAccount) async {
    var result = await http.post(
        Uri.http(AnimeListAPI.apiServer, '$userAccountRoutes'),
        body: userAccount.toMap());
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
  }

  Future get(String login) async {
    var result = await http
        .get(Uri.http(AnimeListAPI.apiServer, '$userAccountRoutes/$login'));
    if (result.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<AuthenticationResult> authenticate(
      String login, String password) async {
    var result = await http.post(Uri.http(AnimeListAPI.apiServer, authRoutes),
        body: {'login': login, 'password': password});
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
    final Map<String, dynamic> datas = jsonDecode(result.body);
    return AuthenticationResult.fromMap(datas);
  }

  Future<String> refreshToken(context) async {
    var token = Provider.of<LoginState>(context, listen: false).token;
    var result = await http.get(
        Uri.http(AnimeListAPI.apiServer, '$userAccountRoutes/refreshtoken'),
        headers: {'Authorization': 'Bearer $token'});
    if (result.statusCode == 200)
      return jsonDecode(result.body)["token"];
    else
      throw StatusErrorException(result.statusCode);
  }
}

class AnimeRoutes extends AnimeListAPI {
  static const animeRoutes = '${AnimeListAPI.apiUrl}/anime.dart';
  var userRoutes = UserAccountRoutes();

  Future<List<ListAnimes>> get(context) async {
    List<ListAnimes> listsAnimes = [];

    try {
      var value = await userRoutes.refreshToken(context);
      Provider.of<LoginState>(context, listen: false).token = value;

      //var token = Provider.of<LoginState>(context, listen: false).token;
      var result = await http.get(
          Uri.http(AnimeListAPI.apiServer, '$animeRoutes'),
          headers: {'Authorization': 'Bearer $value'});
      if (result.statusCode == 200) {
        var datas = jsonDecode(result.body);
        for (var data in datas) {
          var listAnimes = ListAnimes.fromMap(data);
          listsAnimes.add(listAnimes);
        }
      }
    } on StatusErrorException catch (error) {
      if ((error.statusCode == 401))
        Provider.of<LoginState>(context, listen: false).disconnect();
    }
    ;
    return listsAnimes;
  }

  Future insert(ListAnimes anime, context) async {
    var token = Provider.of<LoginState>(context, listen: false).token;
    await http.post(Uri.http(AnimeListAPI.apiServer, animeRoutes),
        headers: {'Authorization': 'Bearer $token'}, body: anime);
  }
}
